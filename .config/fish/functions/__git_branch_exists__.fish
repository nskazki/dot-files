function __git_branch_exists__
  # https://stackoverflow.com/a/52334904/16062729
  git show-ref --quiet --heads $argv
end
