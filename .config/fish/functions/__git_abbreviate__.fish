function __git_abbreviate__
  git rev-parse --short (__git_resolve__ $argv)
end
