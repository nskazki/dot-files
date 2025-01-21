function __write_field__
  set file $argv[1]
  set path (string join '.' -- (quote $argv[2..-2]))
  set value (quote $argv[-1])

  if blank $file || blank $path || blank $value
    return 1
  end

  set output (jq -e ".$path = $value" $file | string collect)

  if present $output
    echo -- $output > $file
  else
    return 1
  end
end
