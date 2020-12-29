function __git_sort_commits__
  for commit in $argv
    set index (math 1 + (git rev-list --count $commit..HEAD))
    set sorted[$index] $commit
  end

  for commit in $sorted
    if present $commit
      echo -- $commit
    end
  end
end
