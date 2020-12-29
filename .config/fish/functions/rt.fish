function rt
  if [ "$argv" = '.' ]
    set commit (__git_find_oldest_tmp__)
  else if present $argv
    set commit $argv
  else
    set commit (gh)
  end

  if blank $commit
    color blue 'target is not selected!'
    return 1
  end

  set latest (__git_find_latest_tmp__)
  if string match -q $commit $latest
    color yellow 'nothing to do!'
    return 1
  end

  echo
  echo (color brblack '$') (color magenta 'GIT_SEQUENCE_EDITOR=~/.bash-tools/rebase-squash-tmp.js') 'git rebase -i' (color cyan $commit)^
  echo
  GIT_SEQUENCE_EDITOR='$HOME/.bash-tools/rebase-squash-tmp.js' git rebase -i $commit^ || return $status

  __git_show__
end
