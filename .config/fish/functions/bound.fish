function bound
  commandline -t -- (eval $argv[1] | string escape | string join ' ')
  commandline -f repaint
end
