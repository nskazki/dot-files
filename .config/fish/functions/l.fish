function l
  if ! __in_git_repo__
    return 1
  end

  echo
  git log-last --first-parent $argv
  echo
end
