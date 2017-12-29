#! /usr/bin/env bash

export DISPLAY=:0

function fix-layout {
  if [ -f "/usr/bin/setxkbmap" ] && [ -n "$XDG_DATA_DIRS" ]; then
    if [ -z "$(setxkbmap -v 6 | grep -s shift_caps_switch)" ]; then
      if [ -n "$(xset -q | grep -P "Caps Lock:\s+on")" ]; then
        xdotool key Caps_Lock
      fi
      /usr/bin/setxkbmap -layout "us,ru" -option "grp:shift_caps_switch,grp_led:caps"
    fi
  fi
}

if [ "$1" == "-l" ]; then
  while true; do
    fix-layout
    sleep 0.5
  done
else
  fix-layout
fi
