#! /usr/bin/env bash
# debug mode: /bin/bash -xv

cmd_pipe="/tmp/record-desktop-cmd-pipe"
gif_pipe="/tmp/record-desktop-gif-pipe"
gif_file=""
gif_dir="$HOME/Videos"

rm -f "$cmd_pipe" && mkfifo "$cmd_pipe" && echo "$cmd_pipe"
rm -f "$gif_pipe" && mkfifo "$gif_pipe" && echo "$gif_pipe"
[[ ! -d "$gif_dir" ]] && mkdir "$gif_dir" && echo "$gif_dir"

while true; do
  if read line < "$cmd_pipe"; then
    #if we get signal, either start or stop recording
    if [[ -n "$gif_file" ]]; then
      echo "put something into the $gif_pipe to interrupt the byzanz-record process" > "$gif_pipe"
      while [[ ! -f "$gif_file" ]]; do sleep 1; done
      xdg-open "$gif_file" &
      notify-send -u "normal" -i "info" "byzanz-record" "Done $gif_file"
      echo "Done $gif_file"
      gif_file=""
    else
      gif_file="$gif_dir/record-desktop-$(date +'%Y-%m-%d_%H-%M-%S')"
      byzanz-record --exec="cat '$gif_pipe'" -- "$gif_file" &
      notify-send -u "normal" -i "info" "byzanz-record" "Started $gif_file"
      echo "Started $gif_file"
    fi
  fi
done
