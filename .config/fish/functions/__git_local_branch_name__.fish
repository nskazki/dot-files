function __git_local_branch_name__
  isatty || read -az argv
  set remotes (string join '|' (git remote))
  string match -g -r -- "^(?:\*)?\s*(?:remotes/)?(?:(?:$remotes)/)?(\S+)" $argv
end
