function head
  if [ -x (command -v ghead) ]
    ghead $argv
  else
    command head $argv
  end
end
