function git-line -a orig_branch base_branch
  if ! __in_git_repo__
    return 1
  end

  if __git_dirty__
    __git_status__
    color red 'cleanup the project first!'
    return 1
  end

  if blank $orig_branch
    set orig_branch (__git_clean_line__ (__git_current_branch__))
  end

  if blank $base_branch
    set base_branch (__git_default_branch__)
  end

  if string match -q -- (__git_default_branch__) $orig_branch
    color red 'cannot line-up the default branch!'
    return 1
  end

  if ! __git_exists__ $orig_branch || ! __git_exists__ $base_branch
    color red 'could not resolve the given arguments!'
    return 1
  end

  set orig_commit (__git_resolve__ $orig_branch)
  set base_commit (__git_base_commit__ $orig_commit $base_branch)

  if blank $base_commit
    color red 'could not figure out the base commit!'
    return 1
  end

  set line_range $base_commit..$orig_commit
  set line_branch __line__{$orig_branch}
  set line_commits (git log --pretty=%h $line_range | tac)

  if blank $line_commits
    color yellow 'nothing to do!'
    return 1
  end

  color brblack "debug: processing $(__git_pluralize_commits__ (count $line_commits)) of $line_range"

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

  set line_tag __line__start__
  if __git_tag_exists__ $line_tag
    echo (color brblack '$') 'git tag -d' (color blue $line_tag)
    git tag -d $line_tag >/dev/null
  end

  echo (color brblack '$') 'git tag' (color blue $line_tag) (color cyan $base_commit)
  git tag $line_tag $base_commit

  echo (color brblack '$') (color magenta 'GIT_HOOKS=0') 'git cherry-pick -x -m1  --strategy-option theirs' (color cyan $line_commits)
  GIT_HOOKS=0 git cherry-pick -x -m1  --strategy-option theirs $line_commits >/dev/null 2>&1

  git-lineup
end
