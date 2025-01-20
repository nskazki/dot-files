function __read_field__
  set file $argv[1]
  set path (string join '.' -- (quote $argv[2..-1]))

  if blank $file || blank $path
    return 1
  end

  jq -e -r ".$path | select(. != null)" $file
end
