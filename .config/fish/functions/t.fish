function t
  if ! upward -q Gleam
    return 1
  end

  if [ "$argv" = '.' ]
    set paths (gm .)
  else
    set paths $argv
  end

  set js_specs (__t_args__ js $paths)
  set rb_specs (__t_args__ rb $paths)

  if blank $paths
    echo (color brblack '$') 'yarn t-vue-dashboard'
    echo
    yarn t-vue-dashboard
    return $status
  end

  if present $js_specs
    echo (color brblack '$') 'yarn t-vue-dashboard-path' (color yellow $js_specs)
    echo
    yarn t-vue-dashboard-path $js_specs || return $status
  end

  if present $rb_specs
    echo (color brblack '$') 'rspec' (color yellow $rb_specs)
    rspec $rb_specs || return $status
  end
end
