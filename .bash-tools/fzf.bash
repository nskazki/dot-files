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

export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export FZF_DEFAULT_OPTS='--height 70%'
export FZF_CTRL_T_OPTS="--height 70% \
                        --preview 'file --mime {} | grep binary > /dev/null 2>&1 \
                                    && echo {} is a binary file \
                                    || (highlight -O ansi -l {} || coderay {} || cat {}) 2> /dev/null | head -500'"
