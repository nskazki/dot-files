function __git_sort_commits__
  for commit in $argv
    set index (math 1 + (__git_distance__ $commit))
    set sorted[$index] $commit
  end

  for commit in $sorted
    if present $commit
      echo -- $commit
    end
  end
end
