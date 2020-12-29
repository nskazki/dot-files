function __git_most_distant_commit__
  set sorted (__git_sort_commits__ $argv)
  echo -- $sorted[-1]
end
