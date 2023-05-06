function git-line -a base_branch
  if ! __in_git_repo__
    return 1
  end

  if __git_dirty__
    __git_status__
    color red 'cleanup the project first!'
    return 1
  end

  set orig_branch (__git_clean_line__ (__git_current_branch__))

  if string match -q (__git_default_branch__) $orig_branch
    color red 'cannot line-up the default branch!'
    return 1
  end

  set orig_commit (__git_resolve__ $orig_branch)

  if blank $base_branch
    set base_branch (__git_base_branch__ $orig_commit)
  end

  set base_commit (git merge-base $base_branch $orig_commit)
  set line_branch {$orig_branch}__line
  set line_commits (git log --pretty=%h $base_commit..$orig_commit | tac)

  color brblack "debug: orig branch: $orig_branch"
  color brblack "       base branch: $base_branch"
  color brblack "       line commits:" (count $line_commits)

  if blank $line_commits
    color yellow 'nothing to do!'
    return 1
  end

  if __git_branch_exists__ $line_branch
    if ! string match -q -- (__git_current_branch__) $line_branch
      echo (color brblack '$') 'git checkout' (color green $line_branch)
      git checkout $line_branch >/dev/null || return $status
    end

    echo (color brblack '$') 'git reset --hard' (color cyan (__git_resolve__ $line_branch)) (color brblack "# to restore $line_branch")
    echo (color brblack '$') 'git reset --hard' (color cyan $base_commit)
    git reset --hard $base_commit >/dev/null || return $status
  else
    echo (color brblack '$') 'git checkout -b' (color green $line_branch) (color cyan $base_commit)
    git checkout -b $line_branch $base_commit >/dev/null || return $status
  end

  echo (color brblack '$') (color magenta 'GIT_HOOKS=0') 'git cherry-pick -x -m1' (color cyan $line_commits)
  GIT_HOOKS=0 git cherry-pick -x -m1 $line_commits >/dev/null 2>&1

  git-lineup
end
