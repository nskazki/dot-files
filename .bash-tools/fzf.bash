#! /usr/bin/env bash

export FZF_DEFAULT_OPTS="\
  --color=dark --height 50% --ansi --reverse --no-sort --multi --preview-window right:40% \
  --bind 'ctrl-s:toggle-sort' \
  --bind 'ctrl-k:preview-up' \
  --bind 'ctrl-j:preview-down'"
