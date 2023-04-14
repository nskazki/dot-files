function upward
  argparse 'q/quiet' -- $argv || return $status

  while true
    set path (path resolve (string join / -- $depth $argv))

    if string match -q $path $lasthpath
      return 1
    end

    if test -e $path
      if ! set -q _flag_quiet
        echo $path
      end

      return
    else
      set -a depth ..
      set lasthpath $path
    end
  end
end
