function upward -a name
  while true;
    set path (realpath (string join / -- $depth $name))

    if string match -q $path $lasthpath
      return 1
    end

    if test -e $path
      echo $path
      return
    else
      set -a depth ..
      set lasthpath $path
    end
  end
end
