function __git_stack__ -a target_branch base_branch
  if blank $target_branch
    set target_branch (__git_current_branch__)
  end

  if blank $base_branch
    set base_branch (__git_default_branch__)
  end

  for hash in (git rev-list --first-parent $base_branch..$target_branch)
    __git_local_branch_name__ $hash
  end
end
