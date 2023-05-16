function __git_relative_path__
  if ! isatty
    while read -l line
      set -a argv $line
    end
  end

  for arg in $argv
    if string match -r -q -- '^/' $arg
      set abs $arg
    else
      set abs (string replace -r -- '^' (git root)/ $arg)
    end

    realpath --relative-to=$PWD $abs
  end
end
