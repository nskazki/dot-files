function __git_tag_exists__
  if present (git tag -l $argv)
    return 0
  else
    return 1
  end
end
