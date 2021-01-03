function bound
  commandline -it -- (eval $argv[1] | string escape | string join ' ')
  commandline -it -- ' '
  commandline -f repaint
end
