function __git_is_range__
  string match -r -q -- '\.\.' $argv
end
