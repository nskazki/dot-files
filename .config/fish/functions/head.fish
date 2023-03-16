function head
  if command -v ghead > /dev/null
    ghead $argv
  else
    command head $argv
  end
end
