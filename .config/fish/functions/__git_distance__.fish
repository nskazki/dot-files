function __git_distance__ -a a b
  if blank $a
    return 1
  end

  if blank $b
    set b HEAD
  end

  git rev-list --count $a..$b
end
