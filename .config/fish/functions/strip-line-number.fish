function strip-line-number
  for arg in $argv
    string match -g -r '^(.*?)(?::\d+|:\d+-\d+)?$' -- $arg
  end
end
