function color -a color_name
  set arg_line $argv[2..]

  if present $arg_line
    echo -- (set_color $color_name)$arg_line(set_color normal)
  else if ! isatty
    while read -l piped_line
      echo -- (set_color $color_name)$piped_line(set_color normal)
    end
  end
end
