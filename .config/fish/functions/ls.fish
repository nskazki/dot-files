function ls
  if command -v gls > /dev/null
    gls -h --color=auto --group-directories-first -1 $argv
  else
    command ls -h --color=auto --group-directories-first -1 $argv
  end
end
