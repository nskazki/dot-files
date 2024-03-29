function rr
  if ! __in_git_repo__
    return 1
  end

  if present $argv
    set commits $argv
  else
    set commits (gh)
  end

  if blank $commits
    color blue 'nothing to combine!'
    return 1
  end

  set most_distant_commit (__git_most_distant_commit__ $commits)

  echo
  echo (color brblack '$') (color magenta COMMITS="'$commits'") (color magenta 'GIT_SEQUENCE_EDITOR=~/.scripts/rebase-recombine.js') 'git rebase -i' (color cyan $most_distant_commit)^
  echo
  COMMITS="$commits" GIT_SEQUENCE_EDITOR="$HOME/.scripts/rebase-recombine.js" git rebase -i $most_distant_commit^ || return $status
  echo
end
