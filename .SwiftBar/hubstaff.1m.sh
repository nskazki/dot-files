#! /usr/bin/env bash

function hubstaff {
  /Applications/Hubstaff.app/Contents/MacOS/HubstaffCLI "$@" --autostart
}

function is_active {
  test "$(hubstaff status | jq .tracking)" = "true"
}

function get_tracked {
  if [[ "$(hubstaff status | jq '.active_project .tracked_today')" =~ ^\"([0-9]+):([0-9]+) ]]; then
    echo "${BASH_REMATCH[1]}h${BASH_REMATCH[2]}"
  fi
}

function hide {
osascript <<EOD
tell application "Hubstaff" to activate
tell application "System Events"
  tell process "Hubstaff"
    set mw to menu bar item "Window" of menu bar 1
    set mc to menu item "Close" of menu 1 of mw
    click mc
  end tell
end tell
EOD
}

if [[ "$1" = "resume" ]]; then
  hubstaff resume
  hide
  exit
elif [[ "$1" = "stop" ]]; then
  hubstaff stop
  exit
fi

if is_active; then
  get_tracked
  echo "---"
  echo "Stop Tracking| bash='$0' param1=stop terminal=false refresh=true"
else
  echo "✨"
  echo "---"
  echo "Resume Tracking| bash='$0' param1=resume terminal=false refresh=true"
fi
