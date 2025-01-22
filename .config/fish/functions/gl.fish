function gl
  if ! __in_git_repo__
    return 1
  end

  git diff --name-only HEAD^ | __git_root_relative__ | path filter -f | fzf
end
