function __git_local_branch_name__
  if ! isatty
    while read -l line
      set -a argv $line
    end
  end

  set remotes (string join '|' (git remote))
  string match -g -r -- "^(?:\*)?\s*(?:remotes/)?(?:(?:$remotes)/)?(\S+)" $argv
end
