function d
  if not __in_git_repo__
    return 1
  end

  git diff $argv
end
