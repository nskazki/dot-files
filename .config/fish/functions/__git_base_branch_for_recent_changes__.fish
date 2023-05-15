function __git_base_branch_for_recent_changes__ -a target_ref
  if blank $target_ref
    set target_ref (__git_current_branch__)
  else
    set target_ref (__git_clean_branch_name__ $target_ref)
  end

  set branch_names (__git_clean_branch_name__ (git branch -l -a))
  set target_commit (__git_resolve__ $target_ref)
  set default_branch (__git_default_branch__)

  if blank $target_commit
    color red "cannot find $target_ref!"
    return 1
  end

  if string match -q -- $target_commit (__git_resolve__ $default_branch)
    color brblack "base: using fallback right away" >&2
    echo $default_branch
    return
  end

  # https://stackoverflow.com/a/55238339/16062729
  set parent_refs (git log --first-parent --decorate --simplify-by-decoration --pretty=%D $target_commit | string split , | string trim | string match -r -e '.' | string match -v -r '^tag: |/?HEAD$' | string match -g -r '^(?:HEAD -> )?(\S+)')

  if not contains $default_branch $parent_refs
    set -a parent_refs $default_branch
  end

  for parent_ref in $parent_refs
    if not contains $parent_ref $branch_names
      continue
    end

    set target_ahead (__git_distance__ $parent_ref $target_commit)

    if test $target_ahead -eq 0
      continue
    end

    if blank $min || test $target_ahead -lt $min
      set min $target_ahead
      set result $parent_ref
      continue
    end

    if test $target_ahead -gt $min
      continue
    end
  end

  if present $result
    color brblack "base: $target_ref" >&2
    echo $result
  else
    color brblack "base: using fallback" >&2
    echo $default_branch
  end
end
