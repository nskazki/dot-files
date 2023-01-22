function kill_lonely_webpack_postexec -a last_command --on-event fish_postexec
  if string match -q -r '^(ys\b)|(yarn start(-|\b))|(webpack(-|\b))' -- $last_command
    for pid in (pgrep webpack)
      set parent (ps -o ppid= -p $pid)
      if present $parent && test $parent -eq 1
        set name (ps -o comm= -p $pid)
        echo Detached $name [$pid] is still running - attempting force kill!
        kill -9 $pid
      end
    end
  end
end
