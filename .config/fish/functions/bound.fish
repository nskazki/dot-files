function bound
  set output (eval (string escape $argv) | string escape | string join ' ')
  if present $output
    commandline -it -- $output
    commandline -it -- ' '
  end
  commandline -f repaint
end
