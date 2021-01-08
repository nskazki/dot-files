function bound
  set output (eval $argv[1] | string escape | string join ' ')
  if present $output
    commandline -it -- $output
    commandline -it -- ' '
  end
  commandline -f repaint
end
