function fish_right_prompt
  set -l last_pipestatus $pipestatus

  if [ (count $last_pipestatus) -gt 1 ]
    set -a prefix 'exit codes are '
  else
    set -a prefix 'exit code is '
  end

  set -a output (__fish_print_pipestatus $prefix '' '|' '' (set_color --bold $fish_color_status) $last_pipestatus)

  set last_duration $CMD_DURATION
  if [ "$last_duration" -ge 10000 ]
    set -a output 'done in' (color yellow (human-interval $last_duration))
  end

  if present $PERCY_TOKEN
    set -a output (set_color blue --background magenta)PERCY:(string shorten -m 7 $PERCY_TOKEN)(set_color normal)
  end

  if present $NODE_ENV
    set -a output (set_color blue --background green)NODE:$NODE_ENV(set_color normal)
  end

  if present $RAILS_ENV
    set -a output (set_color blue --background red)RAILS:$RAILS_ENV(set_color normal)
  end

  if present $output
    echo $output
  end
end
