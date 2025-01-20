function quote
  for arg in $argv
    set escaped (string replace -a '"' '\"' -- $arg)
    echo -- \"$escaped\"
  end
end
