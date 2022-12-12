function clip-set
  if present $argv
    echo -n -- $argv | pbcopy
  else
    pbcopy
  end
end
