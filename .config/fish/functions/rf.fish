function rf
  if ! __in_git_repo__
    return 1
  end

  if __git_dirty__
    __git_status__
    color red 'cleanup the project first!'
    return 1
  end

  if blank (__git_find_latest_tmp__)
    __git_log__
    color red 'last commit is not temporary!'
    return 1
  end

  if [ "$argv" = '.' ]
    set commit HEAD
  else if present $argv
    set commit $argv
  else
    set commit (gh)
  end

  if blank $commit
    color blue 'target is not selected!'
    return 1
  end

  if string match -q $commit (__git_find_latest_tmp__)
    color red 'cannot target itself!'
    return 1
  end

  echo
  echo (color brblack '$') 'git uncommit'
  echo (color brblack '$') 'git commit --fixup' (color cyan $commit)
  git uncommit || return $status
  git commit --quiet --fixup $commit || return $status

  __git_show__
end
