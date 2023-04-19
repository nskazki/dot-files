import sublime
import sublime_plugin
import re
import sys

PYTHON = sys.version_info[0]

if 3 == PYTHON:
    # Python 3 and ST3
    from . import case_parse
else:
    # Python 2 and ST2
    import case_parse


SETTINGS_FILE = "CaseConversion.sublime-settings"


def to_snake_case(text, detectAcronyms, acronyms):
    words, case, sep = case_parse.parseVariable(text, detectAcronyms, acronyms)
    return '_'.join([w.lower() for w in words])


def to_screaming_snake_case(text, detectAcronyms, acronyms):
    words, case, sep = case_parse.parseVariable(text, detectAcronyms, acronyms)
    return '_'.join([w.upper() for w in words])


def to_pascal_case(text, detectAcronyms, acronyms):
    words, case, sep = case_parse.parseVariable(text, detectAcronyms, acronyms)
    return ''.join(words)


def to_camel_case(text, detectAcronyms, acronyms):
    words, case, sep = case_parse.parseVariable(text, detectAcronyms, acronyms)
    words[0] = words[0].lower()
    return ''.join(words)


def to_dot_case(text, detectAcronyms, acronyms):
    words, case, sep = case_parse.parseVariable(text, detectAcronyms, acronyms)
    return '.'.join([w.lower() for w in words])


def to_dash_case(text, detectAcronyms, acronyms):
    words, case, sep = case_parse.parseVariable(text, detectAcronyms, acronyms)
    return '-'.join([w.lower() for w in words])


def to_slash(text, detectAcronyms, acronyms):
    words, case, sep = case_parse.parseVariable(text, detectAcronyms, acronyms, True)
    return '/'.join(words)

def to_backslash(text, detectAcronyms, acronyms):
    words, case, sep = case_parse.parseVariable(text, detectAcronyms, acronyms, True)
    return '\\'.join(words)


def to_separate_words(text, detectAcronyms, acronyms):
    words, case, sep = case_parse.parseVariable(text, detectAcronyms, acronyms, True)
    return ' '.join(words)

def toggle_dash_to_camel(text, detectAcronyms, acronyms):
    if re.search(r"[-_]", text):
        return to_camel_case(text, detectAcronyms, acronyms)
    else:
        return to_dash_case(text, detectAcronyms, acronyms)

def toggle_dash_to_pascal(text, detectAcronyms, acronyms):
    if re.search(r"[-_]", text):
        return to_pascal_case(text, detectAcronyms, acronyms)
    else:
        return to_dash_case(text, detectAcronyms, acronyms)

def toggle_all(text, detectAcronyms, acronyms):
    if re.search(r"^[-_]$", text) or re.search(r"^[0-9]$", text):
        return text
    if re.search(r"^[a-z0-9]+$", text):
        return to_pascal_case(text, detectAcronyms, acronyms)
    elif re.search(r"^[A-Z][a-z0-9]+$", text):
        return to_screaming_snake_case(text, detectAcronyms, acronyms)
    elif re.search(r"^[A-Z0-9]+$", text):
        return to_camel_case(text, detectAcronyms, acronyms)
    elif re.search(r"-", text):
        return to_snake_case(text, detectAcronyms, acronyms)
    elif re.search(r"_", text):
        if re.search(r"^[0-9A-Z_]+$", text):
            return to_camel_case(text, detectAcronyms, acronyms)
        else:
            return to_screaming_snake_case(text, detectAcronyms, acronyms)
    elif re.search(r"^[a-z]", text):
        return to_pascal_case(text, detectAcronyms, acronyms)
    else:
        return to_dash_case(text, detectAcronyms, acronyms)

def run_on_selections(view, edit, func):
    settings = sublime.load_settings(SETTINGS_FILE)
    detectAcronyms = settings.get("detect_acronyms", True)
    useList = settings.get("use_acronyms_list", True)
    if useList:
        acronyms = settings.get("acronyms", [])
    else:
        acronyms = False

    for s in view.sel():
        region = s if s else view.word(s)

        text = view.substr(region)
        # Preserve leading and trailing whitespace
        leading = text[:len(text)-len(text.lstrip())]
        trailing = text[len(text.rstrip()):]
        new_text = leading + func(text.strip(), detectAcronyms, acronyms) + trailing
        if new_text != text:
            view.replace(edit, region, new_text)

class ToggleDashToCamel(sublime_plugin.TextCommand):
    def run(self, edit):
        run_on_selections(self.view, edit, toggle_dash_to_camel)

class ToggleDashToPascal(sublime_plugin.TextCommand):
    def run(self, edit):
        run_on_selections(self.view, edit, toggle_dash_to_pascal)

class ToggleAll(sublime_plugin.TextCommand):
    def run(self, edit):
        run_on_selections(self.view, edit, toggle_all)

class ConvertToSnakeCommand(sublime_plugin.TextCommand):
    def run(self, edit):
        run_on_selections(self.view, edit, to_snake_case)

class ConvertToScreamingSnakeCommand(sublime_plugin.TextCommand):
    def run(self, edit):
        run_on_selections(self.view, edit, to_screaming_snake_case)

class ConvertToCamel(sublime_plugin.TextCommand):
    def run(self, edit):
        run_on_selections(self.view, edit, to_camel_case)

class ConvertToPascal(sublime_plugin.TextCommand):
    def run(self, edit):
        run_on_selections(self.view, edit, to_pascal_case)

class ConvertToDot(sublime_plugin.TextCommand):
    def run(self, edit):
        run_on_selections(self.view, edit, to_dot_case)

class ConvertToDash(sublime_plugin.TextCommand):
    def run(self, edit):
        run_on_selections(self.view, edit, to_dash_case)

class ConvertToSeparateWords(sublime_plugin.TextCommand):
    def run(self, edit):
        run_on_selections(self.view, edit, to_separate_words)

class ConvertToSlash(sublime_plugin.TextCommand):
    def run(self, edit):
        run_on_selections(self.view, edit, to_slash )

class ConvertToBackSlash(sublime_plugin.TextCommand):
    def run(self, edit):
        run_on_selections(self.view, edit, to_backslash )
