function e
  if ! upward -q Gleam
    return 1
  end

  if [ "$argv" = '.' ]
    set paths (gm .)
  else
    set paths $argv
  end

  set js_paths (__e_args__ js $paths)
  set rb_paths (__e_args__ rb $paths)

  if blank $paths
    echo (color brblack '$') 'eslint'
    eslint
    return $status
  end

  if present $js_paths
    echo (color brblack '$') 'eslint' (color yellow $js_paths)
    eslint $js_paths || return $status
  end

  if present $rb_paths
    echo (color brblack '$') 'rubocop' (color yellow $rb_paths)
    echo
    rubocop $rb_paths || return $status
  end
end
