function gm
  if ! __in_git_repo__
    return 1
  end

  set commits (gh)

  if blank $commits
    color blue 'target is not selected!'
    return 1
  end

  for commit in $commits
    set -a files (git diff --name-only $commit^..$commit | __git_relative_path__)
  end

  path filter -f $files | sort | uniq | fzf
end
