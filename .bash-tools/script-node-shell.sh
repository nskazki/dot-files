#! /usr/bin/env bash

function getNodeId {
  xdotool search --name "==node-shell==" | tail  -n 1
}

function runNode {
  gnome-terminal --geometry 80x24+560+200  -e "$HOME/.bash-tools/script-node-shell-setup.sh"
}

function getNodeState {
  xwininfo -id $1 | grep "Map State:"
}

function hideNode {
  xdotool windowunmap $1
}

function getFocusId {
  xdotool getwindowfocus
}

function showNode {
  xdotool windowmap $1
  xdotool windowactivate $1
  xdotool windowfocus $1
}

if [[ -z "$(getNodeId)" ]]; then
  runNode
  exit
fi

if [[ ("$(getNodeState "$(getNodeId)")" == *IsViewable) && ("$(getFocusId)" == "$(getNodeId)") ]]; then
  hideNode "$(getNodeId)"
else
  showNode "$(getNodeId)"
fi
