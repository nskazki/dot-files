function __git_relative_path__
  while read -l line
    set -a argv $line
  end

  if present $argv
    realpath --relative-to=$PWD (string replace -r -- '^' (git root)/ $argv)
  end
end
