function git-drop-smart
  if present $argv
    set commits $argv
  else
    set commits (gh)
  end

  if blank $commits
    color blue 'nothing to drop!'
    return 1
  end

  set most_distant_commit (__git_most_distant_commit__ $commits)

  echo
  echo (color brblack '$') (color magenta COMMITS=\""$commits"\") (color magenta 'GIT_SEQUENCE_EDITOR=~/.scripts/rebase-drop.js') 'git rebase -i' (color cyan $most_distant_commit)^
  echo
  COMMITS="$commits" GIT_SEQUENCE_EDITOR='$HOME/.scripts/rebase-drop.js' git rebase -i $most_distant_commit^ || return $status
  echo
end
