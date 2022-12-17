#! /usr/bin/env bash

if [[ -n "$@" ]]; then
  less -M -- "$@"
else
  shopt -s extglob # https://stackoverflow.com/a/3015564/16062729
  input="$(cat -)"
  lines="$(echo -n "$input" | wc -l)"
  lines="${lines##*( )}"
  limit="$(tput lines)"

  if test "$lines" -gt "$limit"; then
    LESS="$LESS -Pslines %lt-%lb/$lines" less <<< "$input"
  elif test "$lines" -gt 0; then
    echo "$input"
  fi
fi
