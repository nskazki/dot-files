function clip-set
  if present $argv
    echo -n -- $argv | xclip -selection c
  else
    xclip -selection c
  end
end
