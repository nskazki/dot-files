import sublime, sublime_plugin, os
import re

def parse(string):
  chunks = []
  chunk = ''
  is_uppercased = False

  for char in string:
    if not re.search(r'[a-zA-Z0-9]', char):
      if len(chunk) != 0:
        is_uppercased = False
        chunks.append(chunk)
        chunk = ''
    elif re.search(r'[0-9]', char):
      is_uppercased = False
      chunk += char
      chunks.append(chunk)
      chunk = ''
    elif re.search(r'[A-Z]', char):
      if len(chunk) == 0:
        is_uppercased = True
        chunk += char
      elif is_uppercased:
        chunk += char
      else:
        is_uppercased = False
        chunks.append(chunk)
        chunk = char
    else:
      is_uppercased = False
      chunk += char

  if len(chunk) != 0:
    is_uppercased = False
    chunks.append(chunk)

  return chunks

def dash_case(string):
  return '-'.join(parse(string)).lower()

def pascal_case(string):
  result = ''
  for chunk in parse(string):
    normalized = chunk if any(c.islower() for c in chunk) else chunk.lower()
    result += normalized[:1].upper() + normalized[1:]

  return result

def get_file_path(self, forceFullpath):
  fullpath = self.view.file_name()
  folders = sublime.active_window().folders()
  paths = list((os.path.relpath(fullpath, folder) for folder in folders))
  paths.append(fullpath)
  shortpath = min(paths, key=len)
  if forceFullpath or "/node_modules/" in fullpath or shortpath.startswith('../'):
    return fullpath
  else:
    return shortpath

def get_base_name(path):
  result = os.path.basename(path)

  while True:
    control = result
    (result, _ext) = os.path.splitext(result)
    if control == result:
       break

  return re.sub(r'_spec$', '', result)

def get_selected_lines(self):
  (rowStart, colStart) = self.view.rowcol(self.view.sel()[0].begin())
  (rowEnd, colEnd)     = self.view.rowcol(self.view.sel()[0].end())

  if rowStart == rowEnd and colStart == colEnd:
    return ''
  elif rowStart == rowEnd:
    return ':{}'.format(rowStart + 1)
  elif colEnd == 0:
    return ':{}'.format(rowStart + 1)
  else:
    return ':{}-{}'.format(rowStart + 1, rowEnd + 1)

class DirToClipboard(sublime_plugin.TextCommand):
  def run(self, edit):
    result = os.path.dirname(get_file_path(self, False))
    if len(result) == 0:
      result = os.path.dirname(get_file_path(self, True))

    sublime.set_clipboard(result)
    sublime.status_message('Copied the dir : {}'.format(result))

class PathToClipboard(sublime_plugin.TextCommand):
  def run(self, edit):
    result = get_file_path(self, False) + get_selected_lines(self)
    sublime.set_clipboard(result)
    sublime.status_message('Copied the path: {}'.format(result))

class NameToClipboard(sublime_plugin.TextCommand):
  def run(self, edit):
    result = get_base_name(get_file_path(self, False))
    sublime.set_clipboard(result)
    sublime.status_message('Copied the name: {}'.format(result))

class DashNameToClipboard(sublime_plugin.TextCommand):
  def run(self, edit):
    result = dash_case(get_base_name(get_file_path(self, False)))
    sublime.set_clipboard(result)
    sublime.status_message('Copied the dash name: {}'.format(result))

class PascalNameToClipboard(sublime_plugin.TextCommand):
  def run(self, edit):
    result = pascal_case(get_base_name(get_file_path(self, False)))
    sublime.set_clipboard(result)
    sublime.status_message('Copied the pascal name: {}'.format(result))

class FullDirToClipboard(sublime_plugin.TextCommand):
  def run(self, edit):
    result = os.path.dirname(get_file_path(self, True))
    sublime.set_clipboard(result)
    sublime.status_message('Copied the full dir : {}'.format(result))

class FullPathToClipboard(sublime_plugin.TextCommand):
  def run(self, edit):
    result = get_file_path(self, True) + get_selected_lines(self)
    sublime.set_clipboard(result)
    sublime.status_message('Copied the full path: {}'.format(result))

class FullNameToClipboard(sublime_plugin.TextCommand):
  def run(self, edit):
    result = os.path.basename(get_file_path(self, True))
    sublime.set_clipboard(result)
    sublime.status_message('Copied the full name: {}'.format(result))
