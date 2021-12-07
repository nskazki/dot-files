function ls
  if [ -x (command -v gls) ]
    gls -h --color=auto --group-directories-first -1 $argv
  else
    command ls -h --color=auto --group-directories-first -1 $argv
  end
end
