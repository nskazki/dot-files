function __git_local_branch_name__
  while read -l line
    set -a argv $line
  end

  set remotes (string join '|' (git remote))
  string match -g -r -- "^(?:\*)?\s*(?:remotes/)?(?:(?:$remotes)/)?(\S+)" $argv
end
