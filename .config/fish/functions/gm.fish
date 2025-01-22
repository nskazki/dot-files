function gm
  if ! __in_git_repo__
    return 1
  end

  if [ "$argv" = '.' ]
    set commits (git log --pretty=%h (__git_base_branch_for_recent_changes__)..HEAD)
  else if present $argv
    set commits $argv
  else
    set commits (gh)
  end

  if blank $commits
    return 1
  end

  for commit in $commits
    set -a files (git diff --name-only $commit^..$commit | __git_root_relative__)
  end

  set true_files "$(path filter -f $files | sort | uniq)"

  if [ "$argv" = '.' ]
    echo $true_files
  else
    echo $true_files | fzf
  end
end
