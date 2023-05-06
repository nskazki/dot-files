function vv
  if ! __in_git_repo__
    return 1
  end

  git view-commit $argv
end
