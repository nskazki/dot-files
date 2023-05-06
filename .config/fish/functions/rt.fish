function rt
  if ! __in_git_repo__
    return 1
  end

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

  if ! __git_dirty__
    set checkpoint (__git_resolve__ HEAD)
  end

  echo
  echo (color brblack '$') (color magenta 'GIT_SEQUENCE_EDITOR=~/.scripts/rebase-squash-tmp.js') 'git rebase -i' (color cyan $commit)^
  echo
  GIT_SEQUENCE_EDITOR='$HOME/.scripts/rebase-squash-tmp.js' git rebase -i $commit^

  if test $status -eq 0
    __git_show__
  else if set -q checkpoint
    set next (__git_next_tmp_message__ $commit^)

    echo
    echo (color brblack '$') 'git reset --hard' (color cyan $checkpoint) (color brblack '# to restore the squashed commits')
    echo (color brblack '$') 'git rebase --abort' (color blue '&&') 'git reset --soft' (color cyan $commit)^ (color blue '&&') 'git commit -m' (color cyan $next)
    git rebase --abort && git reset --soft $commit^ && git commit --quiet -m $next || return $status
    __git_show__
  else
    return 1
  end
end
