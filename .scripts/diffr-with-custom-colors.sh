#! /usr/bin/env bash

shopt -s extglob # https://stackoverflow.com/a/3015564/16062729
input="$(cat -)"

chars="$(echo -n "$input" | wc -m)"
chars="${chars##*( )}"

lines="$(echo "$input" | wc -l)"
lines="${lines##*( )}"

if test "$lines" -le 5000; then
  diffr --colors refine-removed:none:background:0x8f,0x00,0x34:nobold --colors removed:none:background:0x42,0x00,0x18 --colors refine-added:none:background:0x2d,0x50,0x02:nobold --colors added:none:background:0x14,0x29,0x01 <<< "$input"
elif test "$chars" -gt 0; then
  echo "$input"
fi
