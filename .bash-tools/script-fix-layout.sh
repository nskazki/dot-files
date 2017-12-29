#! /usr/bin/env bash

export DISPLAY=:0

if [ -f "/usr/bin/setxkbmap" ] && [ -n "$XDG_DATA_DIRS" ]; then
  if [ -z "$(setxkbmap -v 6 | grep -s shift_caps_switch)" ]; then
    /usr/bin/setxkbmap -layout "us,ru" -option "grp:shift_caps_switch,grp_led:caps"
    numlockx "on"
  fi
fi
