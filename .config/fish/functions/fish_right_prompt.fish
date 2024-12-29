function fish_right_prompt
  set -l last_pipestatus $pipestatus

  if test "$last_generation" = $status_generation
    return
  end

  set -g last_generation $status_generation

  if test (count $last_pipestatus) -gt 1
    set -a prefix 'exit codes are '
  else
    set -a prefix 'exit code is '
  end

  set -a output (__fish_print_pipestatus $prefix '' '|' '' (set_color --bold $fish_color_status) $last_pipestatus)

  set last_duration $CMD_DURATION
  if test "$last_duration" -ge 10000
    set -a output 'done in' (color yellow (human-interval $last_duration))
  end

  if present $NODE_ENV
    set -a output (set_color black -b green)N:$NODE_ENV(set_color normal)
  end

  if present $RAILS_ENV
    set -a output (set_color black -b yellow)R:$RAILS_ENV(set_color normal)
  end

  if present $output
    echo $output
  end
end
