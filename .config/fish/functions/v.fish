function v
  if ! __in_git_repo__
    return 1
  end

  echo
  git view-commit-head $argv
  echo
end
