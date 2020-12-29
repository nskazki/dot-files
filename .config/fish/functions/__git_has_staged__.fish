function __git_has_staged__
  # https://git-scm.com/book/en/v2/Git-Basics-Recording-Changes-to-the-Repository
  # https://stackoverflow.com/a/2659808
  git update-index -q --ignore-submodules --refresh
  ! git diff-index --cached --quiet HEAD --ignore-submodules
end
