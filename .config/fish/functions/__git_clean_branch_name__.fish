function __git_clean_branch_name__
  while read -l line
    set -a argv $line
  end

  string match -g -r -- '^(?:\*)?\s*(?:remotes/)?(\S+)' $argv
end
