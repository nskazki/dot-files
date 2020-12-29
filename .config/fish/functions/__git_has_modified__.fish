function __git_has_modified__
  git update-index -q --ignore-submodules --refresh
  ! git diff-files --quiet --ignore-submodules
end
