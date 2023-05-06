function __git_base_commit__ -a target_branch base_branch
  if blank $target_branch
    set target_branch (__git_current_branch__)
  end

  if blank $base_branch
    set base_branch (__git_default_branch__)
  end

  if ! __git_exists__ $target_branch || ! __git_exists__ $base_branch
    return 1
  end

  # with PRs, a branch may only be merged once into the base branch
  set base_merged (git-when-merged -c -- $target_branch $base_branch 2>/dev/null)

  if present $base_merged
    git merge-base $base_merged^ $target_branch
  else
    git merge-base $base_branch $target_branch
  end
end
