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
  set git_root (git root)

  if blank $paths
    echo (color brblack '$') 'npm -C' (color yellow $git_root) 'run t-vue-dashboard'
    echo
    npm -C $git_root run t-vue-dashboard
    return $status
  end

  if present $js_specs
    echo (color brblack '$') 'npm -C' (color yellow $git_root) 'run t-vue-dashboard-path' (color yellow $js_specs)
    echo
    npm -C $git_root run t-vue-dashboard-path $js_specs || return $status
  end

  if present $rb_specs
    echo (color brblack '$') 'rspec' (color yellow $rb_specs)
    if __git_in_root__
      rspec $rb_specs || return $status
    else
      fish -c "cd $(git root); rspec $rb_specs" || return $status
    end
  end
end
