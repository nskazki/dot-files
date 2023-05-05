function git-when-branch-merged -a what where base_branch
  if blank $what
    color red 'at least one argument is required!'
    return 1
  end

  if blank $where
    set where (__git_current_branch__)
  end

  if string match -r -q -- '^[a-f0-9]+\.\.[a-f0-9]+$' $what
    set commits (git log --format=%H $what | tac)
  else
    if blank $base_branch
      set base_branch (__git_base_branch__ $what)
    end

    # with PRs, a branch may only be merged once into the default branch
    set base_merged (git-when-merged -c -- $what $base_branch 2>/dev/null)

    if present $base_merged
      set base_commit (git merge-base $base_merged^ $what)
    else
      set base_commit (git merge-base $base_branch $what)
    end

    color brblack "debug: base branch: $base_branch"
    color brblack "       base merged: $base_merged"
    color brblack "       base commit: $base_commit"

    set commits (git log --format=%H $base_commit..$what | tac)
  end

  set commit_count (count $commits)

  if [ $commit_count -eq 0 ]
    color red 'the commit range is empty!'
    return 1
  else if [ $commit_count -gt 200 ]
    color red "the commit range of $commit_count commmits doesn't make sense!"
    return 1
  end

  color brblack "debug: processing $commit_count commits"

  for commit in $commits
    if contains $commit $processed_commits
      continue
    end

    set merges (git-when-merged -c -r -- $commit $where 2>/dev/null)

    if blank $merges
      continue
    end

    if contains $merges[1] $commits
      continue
    end

    set range "$merges[1]^..$merges[1]"
    set -a processed_commits (git log --format=%H $range)

    set -e descriptions
    for merge in $merges
      set -a descriptions "$(git log -n1 --format='via %C(magenta)%h%C(reset) (%s)' $merge)"
    end

    set debug "$commit merged into $where"
    set title "$(string join -- \n $descriptions)"
    set graph "$(git log-hist -n 100 $range)"

    box "$debug"\n"$title"\n\n"$graph"
  end
end
