function cola
  if ! __in_git_repo__
    return 1
  end

  git-cola $argv &
end
