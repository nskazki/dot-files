#! /usr/bin/env bash

if [ -t 0 ]; then
  less -M -- "$@"
else
  shopt -s extglob # https://stackoverflow.com/a/3015564/16062729
  input="$(cat -)"
  limit="$(tput lines)"

  chars="$(echo -n "$input" | wc -m)"
  chars="${chars##*( )}"

  lines="$(echo "$input" | wc -l)"
  lines="${lines##*( )}"

  if test "$lines" -ge "$limit"; then
    LESS="$LESS -Pslines %lt-%lb/$lines" less <<< "$input"
  elif test "$chars" -gt 0; then
    echo "$input"
  fi
fi
