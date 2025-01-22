function __git_in_root__
  string match -q -- $PWD (git root)
end
