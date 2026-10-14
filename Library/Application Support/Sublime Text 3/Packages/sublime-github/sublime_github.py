"""
Copy a GitHub link to the file in the active view.

Trimmed down from https://github.com/bgreenlee/sublime-github (MIT, see LICENSE)
to two commands: a permalink to the commit checked out locally, and a link on the
remote's default branch. Written for the Python 3.3 plugin host of Sublime Text 3.
"""
import os
import re
import shutil
import subprocess
import threading

import sublime
import sublime_plugin


def git_root(directory):
    directory = os.path.realpath(directory)
    while directory:
        if os.path.exists(os.path.join(directory, ".git")):
            return directory
        parent = os.path.dirname(directory)
        if parent == directory:
            break
        directory = parent
    return None


class RemoteUrl(object):
    """
    Everything the two commands share. A plain mixin rather than a TextCommand
    subclass, so that Sublime Text registers only the two commands at the bottom.
    """
    # True links to the commit checked out locally, False to the remote's default branch.
    permalink = False

    def is_enabled(self):
        name = self.view.file_name()
        return bool(name and git_root(os.path.dirname(name)))

    def run_command(self, command, callback):
        directory = os.path.dirname(self.view.file_name())
        executable = shutil.which("git")
        if not executable:
            sublime.error_message("Git binary could not be found. Add git to Sublime Text's PATH.")
            return

        def run():
            try:
                process = subprocess.Popen(
                    [executable] + command[1:], cwd=directory,
                    stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                )
                output = process.communicate()[0].decode("utf-8", errors="replace")
                sublime.set_timeout(lambda: callback(output), 0)
            except OSError as error:
                message = "Git failed: %s" % error
                sublime.set_timeout(lambda: sublime.error_message(message), 0)

        threading.Thread(target=run, daemon=True).start()

    def run(self, edit):
        self.run_command(
            ["git", "rev-parse", "--abbrev-ref", "--symbolic-full-name", "@{upstream}"],
            self.done_rev_parse,
        )

    def done_rev_parse(self, result):
        self.settings = sublime.load_settings("GitHub.sublime-settings")
        self.protocol = self.settings.get("protocol", "https")
        configured_remote = self.settings.get("remote")
        if "fatal:" in result:
            if self.permalink:
                if configured_remote:
                    self.remote = configured_remote
                    self.fetch_remote_url()
                else:
                    self.run_command(["git", "remote"], self.done_remote_list)
                return
            remote = "origin"
        else:
            remote = result.strip().split("/", 1)[0]

        self.remote = configured_remote or remote
        if self.permalink:
            self.fetch_remote_url()
        else:
            self.run_command(
                ["git", "symbolic-ref", "--quiet", "--short", "refs/remotes/%s/HEAD" % self.remote],
                self.done_default_branch,
            )

    def done_remote_list(self, result):
        remotes = result.split()
        if len(remotes) != 1:
            sublime.error_message("Set a remote in GitHub settings to create a permalink without an upstream branch.")
            return
        self.remote = remotes[0]
        self.fetch_remote_url()

    def done_default_branch(self, result):
        branch = result.strip()
        if branch.startswith(self.remote + "/"):
            self.remote_branch = branch[len(self.remote) + 1:]
            self.fetch_remote_url()
        else:
            self.run_command(
                ["git", "for-each-ref", "--format=%(refname:short)",
                 "refs/remotes/%s/main" % self.remote, "refs/remotes/%s/master" % self.remote],
                self.done_default_candidates,
            )

    def done_default_candidates(self, result):
        refs = set(result.split())
        for branch in ("main", "master"):
            if "%s/%s" % (self.remote, branch) in refs:
                self.remote_branch = branch
                self.fetch_remote_url()
                return

        self.remote_branch = self.settings.get("default_branch")
        if self.remote_branch:
            self.fetch_remote_url()
        else:
            sublime.error_message("No default branch found for %s. Fetch the remote or configure default_branch." % self.remote)

    def fetch_remote_url(self):
        # Unlike ls-remote --get-url, this fails for a missing remote instead of echoing its name.
        self.run_command(["git", "remote", "get-url", self.remote], self.done_remote)

    def done_remote(self, result):
        if not result.strip() or result.lstrip().startswith(("fatal:", "error:")):
            sublime.error_message("Cannot resolve Git remote %s: %s" % (self.remote, result.strip()))
            return
        repo_url = result.split()[0]
        repo_url = re.sub(r"^git(@|://)", self.protocol + "://", repo_url)
        # Turn the "host:owner" of an ssh address into "host/owner".
        repo_url = re.sub(r"^(https?://[^/:]+):", r"\1/", repo_url)
        self.repo_url = re.sub(r"\.git$", "", repo_url)
        self.run_command(["git", "rev-parse", "--show-toplevel"], self.done_toplevel)

    def done_toplevel(self, result):
        toplevel_path = result.strip()
        # Keep the opened filename (symlinks included) whenever it is already inside Git's root.
        absolute_path = self.view.file_name()
        try:
            relative_path = os.path.relpath(absolute_path, toplevel_path)
        except ValueError:  # Different drives, e.g. a Windows subst drive vs Git's physical path.
            relative_path = None
        if relative_path is None or relative_path == os.pardir or relative_path.startswith(os.pardir + os.sep):
            # Resolve only the parent directory so a symlinked file keeps its name in the URL.
            parent = os.path.realpath(os.path.dirname(absolute_path))
            root = os.path.realpath(toplevel_path)
            try:
                relative_path = os.path.relpath(os.path.join(parent, os.path.basename(absolute_path)), root)
            except ValueError:
                sublime.error_message("Cannot locate this file within the Git repository.")
                return
        if relative_path == os.pardir or relative_path.startswith(os.pardir + os.sep):
            sublime.error_message("This file is outside the Git repository.")
            return

        self.relative_path = "/" + relative_path.replace("\\", "/")
        self.line_nums = self.selected_lines()
        if self.permalink:
            self.run_command(["git", "rev-parse", "HEAD"], self.done_head)
        else:
            self.copy_url(self.remote_branch)

    def selected_lines(self):
        regions = [region for region in self.view.sel() if not region.empty()]
        if regions:
            start_row, _ = self.view.rowcol(regions[0].begin())
            end_row, end_col = self.view.rowcol(regions[0].end())
            # "Expand selection to line" ends the selection at column 0 of the
            # next line, which should not become part of the link.
            if end_col == 0:
                end_row -= 1
            line_nums = "#L%d" % (start_row + 1)
            if end_row > start_row:
                line_nums += "-L%d" % (end_row + 1)
            return line_nums
        if self.settings.get("always_highlight_current_line"):
            current_row, _ = self.view.rowcol(self.view.sel()[0].begin())
            return "#L%d" % (current_row + 1)
        return ""

    def done_head(self, result):
        if not result.strip() or result.lstrip().startswith(("fatal:", "error:")):
            sublime.error_message("Cannot resolve HEAD: %s" % result.strip())
            return
        self.head = result.strip()
        self.run_command(
            ["git", "branch", "--remotes", "--contains", self.head, "--format=%(refname:short)"],
            self.done_remote_branches,
        )

    def done_remote_branches(self, result):
        if not any(branch.startswith(self.remote + "/") for branch in result.split()):
            sublime.error_message("Push this commit to %s (or fetch its branches) before creating a permalink." % self.remote)
            return
        self.copy_url(self.head)

    def copy_url(self, ref):
        url = "%s/blob/%s%s%s" % (self.repo_url, ref, self.relative_path, self.line_nums)
        sublime.set_clipboard(url)
        sublime.status_message("Remote URL copied to clipboard")


class CopyRemoteUrlPermalinkCommand(RemoteUrl, sublime_plugin.TextCommand):
    permalink = True


class CopyRemoteUrlDefaultCommand(RemoteUrl, sublime_plugin.TextCommand):
    permalink = False
