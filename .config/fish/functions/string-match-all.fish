function string-match-all
  for arg in $argv
    if ! set -q base
      set base $arg
    end

    if ! string match -q -- $base $arg
      return 1
    end
  end
end
