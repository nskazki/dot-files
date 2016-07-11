#!/bin/bash

function rand-port {
  echo $(netstat -atn \
    | awk ' /tcp/ {printf("%s\n",substr($4,index($4,":")+1,length($4) )) }' \
    | sed -e "s/://g" \
    | sort -rnu \
    | awk '{array [$1] = $1} END {i=32768; again=1; while (again == 1) {if (array[i] == i) {i=i+1} else {print i; again=0}}}')
}

function git-server {
  if [[ ("$1" == '--help') || ("$1" == '-h') ]]; then
    echo -e "usage: git-server [path-to-prj-dir]"
    return
  fi

  [ $(which http-server) ] || npm i -g http-server
  [ $(which lt) ] || npm i -g localtunnel
  [ $(which parallelshell) ] || npm i -g parallelshell

  local dir=$([ -n "$1" ] && echo "$1" || echo "$PWD")
  local base=$(basename $dir)
  local port=$(rand-port)

  cd "$dir/.git"
  git --bare update-server-info
  cp hooks/post-update.sample hooks/post-update
  cd - > /dev/null

  parallelshell \
    "http-server '$dir/.git' -p $port" \
    "lt -p $port | sed -e 's/your url is: /git clone /' -e 's/.me/.me $base/'"
}

git-server $@
