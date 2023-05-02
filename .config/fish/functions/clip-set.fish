function clip-set
  if isatty
    echo -n -- $argv | pbcopy
  else
    pbcopy
  end
end
