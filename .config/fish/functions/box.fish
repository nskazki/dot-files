function box
  set colors '#66bb6a' '#ec407a' '#3895d3' '#ff7043' '#26a69a' '#7986cb' '#ffa701' '#e17f93'

  while true
    set color (random choice $colors)
    if not string match -q -- $color $__box_last_color
      set -U __box_last_color $color
      break
    end
  end

  set width (math $COLUMNS - 2)

  for line in (string split \n -- $argv)
    # a bug in shorten prevents us from passing each $line or $argv to it
    if [ (string length --visible $line) -gt $width ]
      set -a lines (string shorten -m $width -- $line)
    else
      set -a lines $line
    end
  end

  gum style --border="normal" --border-foreground=$color --width=$width -- $lines
end
