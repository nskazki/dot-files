#! /usr/bin/env bash

# Setup fzf
# ---------
if [[ ! "$PATH" == */home/nskazki/.fzf/bin* ]]; then
  export PATH="$PATH:/home/nskazki/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/nskazki/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/nskazki/.fzf/shell/key-bindings.bash"

export FZF_EXCLUDE='-E .git -E .npm -E node_modules/ -E .cache/ -E cache/ -E .tmp/ -E tmp/ -E bower_components/ -E coverage/ -E .gem/ -E .nvm/ -E .rbenv/ -E coverage_unit/ -E surefire-reports/ -E coverage-reports/'

export FZF_DEFAULT_COMMAND='git branch > /dev/null 2>&1 && ([ "$(git root)" == "$HOME" ] && fd -H -I -t f '"$FZF_EXCLUDE"' || fd -H -t f '"$FZF_EXCLUDE"') || fd -I -H -t f '"$FZF_EXCLUDE"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export FZF_CTRL_T_OPTS="--height 70% \
                        --preview '((echo $(basename {}) | grep .svg > /dev/null 2>&1 && rsvg {} tmp/preview.png && img2txt tmp/preview.png) \
                                     || (file --mime {} | grep image > /dev/null 2>&1 && img2txt {}) \
                                     || (file --mime {} | grep binary > /dev/null 2>&1 && echo {} is a binary file) \
                                     || (highlight -O ansi -l {} || coderay {} || cat {})) 2> /dev/null | head -500'"
