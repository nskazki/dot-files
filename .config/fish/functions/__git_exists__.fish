function __git_exists__
  if present (__git_resolve__ $argv)
    return 0
  else
    return 1
  end
end
