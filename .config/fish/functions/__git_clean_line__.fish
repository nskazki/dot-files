function __git_clean_line__
  string match -r -g -- '^(.+?)(?:__line)?$' $argv
end
