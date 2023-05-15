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

  if __git_exists__ REBASE_HEAD
    set needs_soft_reset
  end

  if ! set -q needs_soft_reset
    echo
    echo (color brblack '$') (color magenta 'GIT_SEQUENCE_EDITOR=~/.scripts/rebase-squash-tmp.js') (color magenta 'GIT_HOOKS=0') 'git rebase -i' (color cyan $commit)^
    echo
    GIT_SEQUENCE_EDITOR="$HOME/.scripts/rebase-squash-tmp.js" GIT_HOOKS=0 git rebase -i $commit^

    if ! string match -- $status 0
      set needs_soft_reset
      set needs_rebase_abort
    end
  end

  if set -q needs_soft_reset
    if ! set -q checkpoint
      color red "clean up the project to do the soft reset!"
      return 1
    end

    set next (__git_next_tmp_message__ $commit^)

    echo

    if set -q needs_rebase_abort
      echo (color brblack '$') 'git rebase --abort'
      git rebase --abort || return $status
    end

    echo (color brblack '$') 'git reset --hard' (color cyan $checkpoint) (color brblack '# to restore the squashed commits')
    echo (color brblack '$') 'git reset --soft' (color cyan $commit)^
    echo (color brblack '$') 'git commit -m' (color cyan $next)
    git reset --soft $commit^ || return $status
    git commit --quiet -m $next || return $status
  end

  __git_show__
end
