function __git_local_branch_name__ -a target_ref
  if blank $target_ref
    set target_ref HEAD
  end

  set target_hash (__git_resolve__ $target_ref)

  if blank $target_hash
    return 2
  end

  set branch_ref (git for-each-ref refs/heads --format='%(refname:short)' --points-at $target_hash)

  if present $branch_ref
    echo $branch_ref
  else
    return 1
  end
end
