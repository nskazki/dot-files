function human-interval
  set input (math $argv / 1000)

  set h (math "floor($input / 3600)")
  set m (math "floor(($input % 3600) / 60)")
  set s (math "floor($input % 60)")

  if [ "$h" -ne 0 ]
    echo $h'h'$m
  else if [ "$m" -ne 0 ]
    echo $m'm'$s
  else
    echo $s's'
  end
end
