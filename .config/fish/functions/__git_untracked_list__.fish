function __git_untracked_list__
  git ls-files --others --exclude-standard --full-name -- (git root) | __git_root_relative__
end
