function __git_clean_branch_name__
  if ! isatty
    while read -l line
      set -a argv $line
    end
  end

  string match -g -r -- '^(?:\*)?\s*(?:remotes/)?(\S+)' $argv
end
