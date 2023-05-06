function ds
  if ! __in_git_repo__
    return 1
  end

  git diff-staged $argv
end
