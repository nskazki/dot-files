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

def pascal_case(string):
  result = ''
  for chunk in parse(string):
    normalized = chunk if any(c.islower() for c in chunk) else chunk.lower()
    result += normalized[:1].upper() + normalized[1:]

  return result

def is_last_line_selected(self):
  entire_file_region = sublime.Region(0, self.view.size())
  last_line_region = self.view.line(entire_file_region.end())
  current_selection = self.view.sel()[0]
  return current_selection.intersects(last_line_region)

def get_above_text(self):
  if is_last_line_selected(self):
    return

  current_cursor = self.view.sel()[0].end()
  current_line = self.view.line(current_cursor)
  above_region = sublime.Region(0, current_line.end())
  return self.view.substr(above_region)

def get_whole_text(self):
  whole_region = sublime.Region(0, self.view.size())
  return self.view.substr(whole_region)

def cut_at_the_closest_def(above_text):
  if not above_text:
    return

  regex = r'[\s\S]*\n\s*def\s+(?:self\.)?[0-9a-zA-Z_?!]+(;|\(|\n|$)'
  match = re.search(regex, above_text)
  if match:
    return match.group()

def cut_at_the_first_def(whole_text):
  if not whole_text:
    return

  regex = r'[\s\S]*?\n\s*def\s+(?:self\.)?[0-9a-zA-Z_?!]+(;|\(|\n|$)'
  match = re.search(regex, whole_text)
  if match:
    return match.group()

def is_private_method(with_def):
  match = re.search(r'\n\s*private\n', with_def)
  if match:
    return True

def is_static_method(with_def):
  # return False
  last_line = get_last_line(with_def)
  self_match = re.search(r'def\s+self\.', last_line)
  if self_match:
    return True

  space_match = re.search(r'\s*(?=\s\sdef\s)', last_line)
  if not space_match:
    return False

  spaces = space_match.group()
  open_re = r'[\s\S]*\n{}class\s<<\sself\s*\n'.format(spaces)
  close_re = r'[\s\S]*\n{}end\s*\n'.format(spaces)

  open_match = re.search(open_re, with_def)
  close_match = re.search(close_re, with_def)

  if not open_match:
    return False
  if not close_match:
    return True
  else:
    return count_lines(open_match.group()) > count_lines(close_match.group())

def extract_method_name(with_def):
  regex = r'def\s+(?:self\.)?([0-9a-zA-Z_?!]+)(;|\(|$)'
  match = re.search(regex, get_last_line(with_def))
  if match:
    return match.group(1)

def get_last_line(text):
  if text:
    return text.splitlines()[-1]
  else:
    return ''

def count_lines(text):
  if text:
    return len(text.splitlines())
  else:
    return 0

def format_method_info(self):
  with_def = cut_at_the_closest_def(get_above_text(self)) or cut_at_the_first_def(get_whole_text(self))
  if not with_def:
    return [None, None, None]

  method_name = extract_method_name(with_def)
  if not method_name:
    return [None, None, None]

  is_static = is_static_method(with_def)
  is_private = is_private_method(with_def)
  return [method_name, is_static, is_private]

def format_service_name(self):
  path = self.view.file_name()
  match = re.search(r'(?:app/lib/services/|app/lib/jobs/)(.*?)(?:\.rb)', path)
  if not match:
    return

  words = match.group(1).split('/')
  parts = list(map(pascal_case, words))
  return '::'.join(parts)

def with_method_name(self, service_name):
  method_name, is_static, is_private = format_method_info(self)
  if not method_name:
    return service_name

  if not is_static:
    service_name += '.new'

  if is_private:
    return service_name + '.send(:{})'.format(method_name)
  else:
    return service_name + '.' + method_name

class MethodNameToClipboard(sublime_plugin.TextCommand):
  def run(self, edit):
    method_name, _, _ = format_method_info(self)

    if not method_name:
      sublime.status_message('No methods!')
      return

    sublime.set_clipboard(method_name)
    sublime.status_message('Copied: {}'.format(method_name))

class ServiceNameToClipboard(sublime_plugin.TextCommand):
  def run(self, edit):
    service_name = format_service_name(self)

    if not service_name:
      sublime.status_message('Not a service!')
      return

    sublime.set_clipboard(service_name)
    sublime.status_message('Copied: {}'.format(service_name))

class ServiceWithMethodNameToClipboard(sublime_plugin.TextCommand):
  def run(self, edit):
    service_name = format_service_name(self)

    if not service_name:
      sublime.status_message('Not a service!')
      return

    extended_service_name = with_method_name(self, service_name)

    sublime.set_clipboard(extended_service_name)
    sublime.status_message('Copied: {}'.format(extended_service_name))
