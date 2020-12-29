function __git_untracked_list__
  git ls-files --others --exclude-standard --full-name -- (git root)
end
