function __git_resolve__ -a target
  if blank $target
    set target HEAD
  end

  set result (git rev-parse --revs-only $target)

  if present  $result
    echo $result
  else
    return 1
  end
end
