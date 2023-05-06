function git-when-branch-merged -a what where base_branch limit
  if blank $what
    color red 'at least specify what to look for!'
    return 1
  end

  if blank $where
    set where (__git_current_branch__)
  end

  if blank $limit
    set limit 200
  end

  if ! __git_exists__ $what || ! __git_exists__ $where
    color red 'could not resolve the given arguments!'
    return 1
  end

  if __git_is_range__ $what
    set range $what
  else
    if blank $base_branch
      set base_branch (__git_default_branch__)
    end

    set base_commit (__git_base_commit__ $what $base_branch)
    if blank $base_commit
      color red 'could not figure out the base commit!'
      return 1
    end

    set range $base_commit..$what
  end

  set commits (git log --format=%H $range | tac)
  set commit_count (count $commits)

  if [ $commit_count -eq 0 ]
    color red "$range is empty!"
    return 1
  else if [ $commit_count -gt $limit ]
    color red "$range of $commit_count commmits doesn't make sense!"
    return 1
  end

  color brblack "debug: processing $(__git_pluralize_commits__ $commit_count) of $range"

  for commit in $commits
    if contains $commit $merged_commits
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
    set -a merged_commits (git log --format=%H $range)

    set -e descriptions
    for merge in $merges
      set -a descriptions "via $(__git_inline_info__ $merge)"
    end

    set debug "$(__git_pluralize_commits__ (math (__git_distance__ $range) - 1)), including $(__git_abbreviate__ $commit), merged into $where"
    set title "$(string join -- \n $descriptions)"
    set graph "$(git log-hist $range)"

    box "$debug"\n"$title"\n\n"$graph"
  end


  if contains $where (git branch -a -l | __git_clean_branch_name__)
    color brblack "debug: validating the output"

    set directly_in_what (git log --format=%H --first-parent $base_commit..$what)
    set directly_in_where (git log --format=%H --first-parent $base_commit..$where)

    for commit in $commits
      if contains $where (git branch -a --contains $commit | __git_clean_branch_name__)
        if ! contains $commit $merged_commits
          set -e directly_in_both
          set -e directly_in_neither

          if contains $commit $directly_in_where && contains $commit $directly_in_what
            set directly_in_both
          end

          if ! contains $commit $directly_in_where && ! contains $commit $directly_in_what
            color brblack "debug: can't validate $(__git_abbreviate__ $commit) because it was merged into $what"
            set directly_in_neither
          end

          # If it's not reported, present in $where, and directly in both, then $where is branched from $what.
          # If it's not reported, present in $where, and not directly in either, then another branch has been merged into $what, and either we have a bug or $where is branch from $what
          if ! set -q directly_in_both && ! set -q directly_in_neither
            set -a not_reported $commit
          end
        end
      else
        if contains $commit $merged_commits
          set -a not_present $commit
        end
      end
    end
  else
    color brblack "debug: replace $where with a branch name to validate the output!"
  end

  if present $not_reported
    echo
    echo "The following $(__git_pluralize_commits__ (count $not_reported)) are present in $where but not reported as merged. There's a bug!"
    echo
    for commit in $not_reported
      __git_inline_info__ $commit
    end
  end

  if present $not_present
    echo
    echo "The following $(__git_pluralize_commits__ (count $not_present)) are reported as merged but aren't present in $where. There's a bug!"
    echo
    for commit in $not_present
      __git_inline_info__ $commit
    end
  end

  if present $not_reported || present $not_present
    echo
    return 1
  end
end
