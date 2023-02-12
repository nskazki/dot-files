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

  if present $DIRECTUS_URL
    set domain (string match -g -r '^(?:https?://)?(\w+)' -- $DIRECTUS_URL)
    if string match -q -r gleam -- $domain
      set color red
    else
      set color blue
    end

    set -a output (set_color -b $color)DU:$domain(set_color normal)
  end

  if present $DIRECTUS_TOKEN
    set -a output (set_color -b blue)DT:(string shorten -m 6 -- $DIRECTUS_TOKEN)(set_color normal)
  end

  if present $PERCY_TOKEN
    set -a output (set_color -b magenta)P:(string shorten -m 6 -- $PERCY_TOKEN)(set_color normal)
  end

  if present $NODE_ENV
    set -a output (set_color -b green)N:$NODE_ENV(set_color normal)
  end

  if present $RAILS_ENV
    set -a output (set_color -b yellow)R:$RAILS_ENV(set_color normal)
  end

  if present $output
    echo $output
  end
end
