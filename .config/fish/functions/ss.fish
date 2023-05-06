function ss
  if ! __in_git_repo__
    return 1
  end

  git status $argv
end
