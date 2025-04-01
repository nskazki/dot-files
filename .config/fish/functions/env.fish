function env
  if command -v genv > /dev/null
    genv $argv
  else
    command env $argv
  end
end
