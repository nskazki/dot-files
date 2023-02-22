function __git_base_branch__ -a target_ref
  if blank $target_ref
    set target_ref (git rev-parse --revs-only --abbrev-ref HEAD)
  else
    set target_ref (string match -g -r '^(?:remotes/)?(\S+)' -- $target_ref)
  end

  set branch_names (git branch -l -a | string match -g -r '^(?:\*)?\s+(?:remotes/)?(\S+)')
  set target_commit (git rev-parse --revs-only $target_ref)
  set default_branch (git config --get init.defaultBranch || echo 'master')

  if blank $target_commit
    color red "cannot find $target_ref!"
    return 1
  end

  if contains $target_ref $branch_names
    set target_branch (string match -g -r '^(?:remotes/[^/]+/)?(.+)$' -- $target_ref)
  end

  if string match -q -- $target_branch $default_branch
    color brblack "debug: using fallback right away" >&2
    echo $default_branch
    return 0
  end

  # https://stackoverflow.com/a/55238339/16062729
  set parent_refs (git log --decorate --simplify-by-decoration --pretty=%D $target_commit | string split , | string trim | string match -r -e '.' | string match -v -r '^tag: |/?HEAD$' | string match -g -r '^(?:HEAD -> )?(\S+)')

  if not contains $default_branch $parent_refs
    set -a parent_refs $default_branch
  end

  for parent_ref in $parent_refs
    if not contains $parent_ref $branch_names
      color brblack "debug: $parent_ref is not a branch name" >&2
      continue
    end

    if string match -q -- $parent_ref $target_branch || string match -q -- $parent_ref "*/$target_branch" || string match -q -- "*/$parent_ref" $target_branch
      color brblack "debug: $parent_ref matches $target_branch" >&2
      continue
    end

    set target_ahead (git rev-list --count $parent_ref..$target_commit)

    if test $target_ahead -eq 0
      color brblack "debug: $parent_ref is ahead or up-to-date with $target_ref" >&2
      continue
    end

    if blank $min || test $target_ahead -lt $min
      set min $target_ahead
      set result $parent_ref
      color brblack "debug: $parent_ref is $target_ahead commits behind $target_ref  " >&2
      continue
    end

    if test $target_ahead -gt $min
      continue
    end

    if string match -q -- $result $default_branch
      continue
    end

    if string match -q -- $parent_ref $default_branch
      color brblack "debug: $parent_ref is better than $result" >&2
      set result $parent_ref
      continue
    end

    set branch_length (echo -n $parent_ref | wc -m | string trim)
    set result_length (echo -n $result | wc -m | string trim)

    if test $branch_length -lt $result_length
      color brblack "debug: $parent_ref is shorter than $result" >&2
      set result $parent_ref
      continue
    end
  end

  if present $result
    echo $result
  else
    color brblack "debug: using fallback" >&2
    echo $default_branch
  end
end
