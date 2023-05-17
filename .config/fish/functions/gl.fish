function gl
  if ! __in_git_repo__
    return 1
  end

  git diff --name-only HEAD^ | __git_relative_path__ | path filter -f | fzf
end
