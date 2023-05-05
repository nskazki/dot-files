function __git_gt_commit__ -a a b
  if blank $a || blank $b
    return 0
  end

  set distance_a (__git_distance__ $a)
  set distance_b (__git_distance__ $b)

  test $distance_a -gt $distance_b
end
