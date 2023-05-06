function g
  if not __in_git_repo__
    return 1
  end

  tig $argv
end
