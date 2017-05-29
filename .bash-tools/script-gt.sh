#! /usr/bin/env bash

function getGtId {
  xdotool search --name "Google Переводчик"
}

function runGt {
  google-chrome --app=https://translate.google.com
}

function getGtState {
  xwininfo -id $1 | grep "Map State:"
}

function hideGt {
  xdotool windowunmap $1
}

function getFocusId {
  xdotool getwindowfocus
}

function showGt {
  xdotool windowmap $1
  xdotool windowactivate $1
  xdotool windowfocus $1
}

if [[ -z "$(getGtId)" ]]; then
  runGt
  exit
fi

if [[ ("$(getGtState "$(getGtId)")" == *IsViewable) && ("$(getFocusId)" == "$(getGtId)") ]]; then
  hideGt "$(getGtId)"
else
  showGt "$(getGtId)"
fi
