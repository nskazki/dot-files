function realpath
  if command -v grealpath > /dev/null
    grealpath $argv
  else
    command realpath $argv
  end
end
