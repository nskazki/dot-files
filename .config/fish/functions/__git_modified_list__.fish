function __git_modified_list__
  git diff-files --name-only -r --ignore-submodules
end
