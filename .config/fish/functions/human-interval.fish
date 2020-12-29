function human-interval
  set input (math $argv / 1000)

  set h (math "round($input / 3600)")
  set m (math "round(($input % 3600) / 60)")
  set s (math "round($input % 60)")

  if [ "$h" -ne 0 ]
    printf "%02d:%02d:%02d\n" $h $m $s
  else if [ "$m" -ne 0 ]
    echo $m'm'$s's'
  else
    echo $s's'
  end
end
