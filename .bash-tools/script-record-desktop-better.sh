#! /usr/bin/env bash
# debug mode: /bin/bash -xv

cmd_pipe="/tmp/record-desktop-better-cmd-pipe"
webm_pipe="/tmp/record-desktop-better-webm-pipe"
webm_file=""
webm_dir="$HOME/Videos"

rm -f "$cmd_pipe" && mkfifo "$cmd_pipe" && echo "$cmd_pipe"
rm -f "$webm_pipe" && mkfifo "$webm_pipe" && echo "$webm_pipe"
[[ ! -d "$webm_dir" ]] && mkdir "$webm_dir" && echo "$webm_dir"

while true; do
  if read line < "$cmd_pipe"; then
    #if we get signal, either start or stop recording
    if [[ -n "$webm_file" ]]; then
      echo "put something into the $webm_pipe to interrupt the byzanz-record process" > "$webm_pipe"
      while [[ ! -f "$webm_file" ]]; do sleep 1; done
      xdg-open "$webm_file" &
      notify-send -u "normal" -i "info" "byzanz-record" "Done $webm_file"
      echo "Done $webm_file"
      webm_file=""
    else
      webm_file="$webm_dir/record-desktop-better-$(date +'%Y-%m-%d_%H-%M-%S').webm"
      byzanz-record --cursor --exec="cat '$webm_pipe'" -- "$webm_file" &
      notify-send -u "normal" -i "info" "byzanz-record" "Started $webm_file"
      echo "Started $webm_file"
    fi
  fi
done
