function __git_staged_list__
  git diff-index --cached --name-only -r --ignore-submodules HEAD
end
