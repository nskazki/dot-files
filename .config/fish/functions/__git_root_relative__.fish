function __git_root_relative__
  if ! isatty
    while read -l line
      set -a argv $line
    end
  end

  for file in $argv
    if __git_in_root__
      echo -- $file
    else
      echo -- (git root)/$file
    end
  end
end
