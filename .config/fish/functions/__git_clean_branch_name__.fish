function __git_clean_branch_name__
  isatty || read -az argv
  string match -g -r -- '^(?:\*)?\s*(?:remotes/)?(\S+)' $argv
end
