function rh
  if ! __in_git_repo__
    return 1
  end

  if [ "$argv" = '.' ] && blank (__git_find_every_tmp__)
    color yellow 'nothing to do!'
    return 1
  end

  if [ "$argv" = '.' ]
    set commits (__git_find_every_tmp__)
  else if present $argv
    set commits $argv
  else
    set commits (gh)
  end

  if blank $commits
    color blue 'nothing to hoist!'
    return 1
  end

  set most_distant_commit (__git_most_distant_commit__ $commits)

  echo
  echo (color brblack '$') (color magenta COMMITS=\""$commits"\") (color magenta 'GIT_SEQUENCE_EDITOR=~/.scripts/rebase-hoist.js') (color magenta 'GIT_HOOKS=0') 'git rebase -i' (color cyan $most_distant_commit)^
  echo
  COMMITS="$commits" GIT_SEQUENCE_EDITOR='$HOME/.scripts/rebase-hoist.js' GIT_HOOKS=0 git rebase -i $most_distant_commit^ || return $status
  echo
end
