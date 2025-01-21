function relative
  if ! isatty
    while read -l line
      set -a argv $line
    end
  end

  if present $argv
    realpath --relative-to=$PWD $argv
  end
end
