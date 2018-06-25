#! /usr/bin/env bash

# Auto-completion
# ---------------
# [[ $- == *i* ]] && source "/home/nskazki/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/nskazki/.app/fzf/shell/key-bindings.bash"

export FZF_EXCLUDE='-E .git -E .npm -E node_modules/ -E .cache/ -E cache/ -E .tmp/ -E tmp/ -E bower_components/ -E coverage/ -E .gem/ -E .nvm/ -E .rbenv/ -E coverage_unit/ -E surefire-reports/ -E coverage-reports/'

export FZF_DEFAULT_COMMAND='git branch > /dev/null 2>&1 && ([ "$(git root)" == "$HOME" ] && fd -H -I -t f '"$FZF_EXCLUDE"' || fd -H -t f '"$FZF_EXCLUDE"') || fd -I -H -t f '"$FZF_EXCLUDE"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export FZF_CTRL_T_OPTS="--preview '((echo $(basename {}) | grep .svg > /dev/null 2>&1 && rsvg {} tmp/preview.png && catimg tmp/preview.png) \
                                     || (file --mime {} | grep image > /dev/null 2>&1 && catimg {}) \
                                     || (file --mime {} | grep binary > /dev/null 2>&1 && echo {} is a binary file) \
                                     || (highlight -O ansi -l {} || coderay {} || cat {})) 2> /dev/null | head -500'"

export FZF_ALT_C_OPTS=" --preview 'ls -a --color -h --group-directories-first -1 -w $(tput cols) {} | head -500'"

export FZF_DEFAULT_OPTS="--color=dark --height 50% --ansi --reverse --no-sort --multi --preview-window right:40% \
                         --bind 'ctrl-s:toggle-sort' \
                         --bind 'ctrl-k:preview-up' \
                         --bind 'ctrl-j:preview-down' \
                         --bind 'ctrl-y:preview-up' \
                         --bind 'ctrl-e:preview-down' \
                         --bind 'ctrl-b:preview-up+preview-up+preview-up' \
                         --bind 'ctrl-f:preview-down+preview-down+preview-down'"
