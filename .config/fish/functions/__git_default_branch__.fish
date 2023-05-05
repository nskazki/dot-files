function __git_default_branch__
  git config --get init.defaultBranch || echo 'master'
end
