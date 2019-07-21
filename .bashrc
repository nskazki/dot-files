# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# http://habrahabr.ru/post/198482/
export HISTCONTROL='ignoreboth:ignoredups:ignorespace:erasedups'
# Append to the history file, don't overwrite it
shopt -s histappend
# Setting history length
export HISTSIZE=-1
export HISTFILESIZE=10000

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# turn on dot files
shopt -s dotglob

# Set bash options
bind 'set completion-ignore-case on'
bind 'set completion-map-case on'
bind 'set completion-query-items -1'
bind 'set show-all-if-ambiguous on'
bind 'set show-all-if-unmodified on'
bind 'set page-completions off'
bind 'set match-hidden-files on'
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

# Alias definitions
if [ -f "$HOME/.bash-tools/bash-aliases" ]; then
  source "$HOME/.bash-tools/bash-aliases"
fi

# Color map
cr_reset="\e[0m"

cr_black="\e[0;30m"
cr_red="\e[0;31m"
cr_green="\e[0;32m"
cr_yellow="\e[0;33m"
cr_blue="\e[0;34m"
cr_magenta="\e[0;35m"
cr_cyan="\e[0;36m"
cr_white="\e[0;37m"

cr_black_b="\e[1;30m"
cr_red_b="\e[1;31m"
cr_green_b="\e[1;32m"
cr_yellow_b="\e[1;33m"
cr_blue_b="\e[1;34m"
cr_magenta_b="\e[1;35m"
cr_cyan_b="\e[1;36m"
cr_white_b="\e[1;37m"

cr_black_bg="\e[1;40m"
cr_red_bg="\e[1;41m"
cr_green_bg="\e[1;42m"
cr_yellow_bg="\e[1;43m"
cr_blue_bg="\e[1;44m"
cr_magenta_bg="\e[1;45m"
cr_cyan_bg="\e[1;46m"
cr_white_bg="\e[1;47m"

cr_black_i="\e[0;90m"
cr_red_i="\e[0;91m"
cr_green_i="\e[0;92m"
cr_yellow_i="\e[0;93m"
cr_blue_i="\e[0;94m"
cr_magenta_i="\e[0;95m"
cr_cyan_i="\e[0;96m"
cr_white_i="\e[0;97m"

# helpers
[[ "$TERM" == xterm* ]] && export COOL_TERM=1

# exports
export check_know_call_time=0
export last_call_time=0
export last_done_time=0
export last_diff_time=0
export last_diff_time_human=""
export last_cmd_done=0
export last_cmd_code=0
export last_cmd=""
export curr_short_pwd
export prev_short_pwd

# Promt

# bash_count part
if [[ "$SHLVL" -eq 1 ]]; then bashcount_p=""
else bashcount_p="\[$cr_magenta_i\]bash#$SHLVL\[$cr_reset\] "; fi

# host part
if [[ "$HOSTNAME" =~ (xyn|eevee) ]]; then cr_host="$cr_cyan_i"
else cr_host="$cr_cyan_bg"; fi
host_p="\[$cr_host\]$HOSTNAME\[$cr_reset\] "

# user part
if [[ "$USER" == "root" ]]; then user_p="\[$cr_red_bg\]$USER\[$cr_reset\] ";
elif [[ "$USER" != "nskazki" ]]; then user_p="\[$cr_red_i\]$USER\[$cr_reset\] ";
else user_p=""; fi

prompt_command_() {
  # sync history
  history -a
  history -c
  history -r

  # git part
  if (git rev-parse --abbrev-ref HEAD >/dev/null 2>&1) && (type -t __git_ps1 > /dev/null); then
    local git_ps1="$(__git_ps1 '%s')"
    local git_ps1_cr="$cr_green_i"
    local git_file_count=""
    local git_stash=""

    if [[ "$(basename "$PWD")" == ".git" ]]; then git_ps1_cr="$cr_yellow_bg";
    elif [[ "$(git rev-parse --is-bare-repository)" == "true" ]]; then git_ps1_cr="$cr_green_bg"
    else
      # git_stash
      local git_sl="$(git stash list | wc -l)"
      if [[ "$git_sl" -ne 0 ]]; then
        git_stash="\[$cr_yellow_i\]stash[$git_sl]\[$cr_reset\] "
      fi

      # git_ps1_cr & git_file_count
      local git_ss="$(git status -s)"

      local modified_staged="$(grep -c -s -P '^M' <<< "$git_ss")"
      if [[ "$modified_staged" -ne 0 ]]; then
        git_ps1_cr="$cr_blue_b"
        git_file_count="\[$git_ps1_cr\][M$modified_staged]\[$cr_reset\]$git_file_count"
      fi

      local modified_notstaged="$(grep -c -s -P '^.M' <<< "$git_ss")"
      if [[ "$modified_notstaged" -ne 0 ]]; then
        git_ps1_cr="$cr_blue_bg"
        git_file_count="\[$git_ps1_cr\][M$modified_notstaged]\[$cr_reset\]$git_file_count"
      fi

      local renamed="$(grep -c -s -P '^R' <<< "$git_ss")"
      if [[ "$renamed" -ne 0 ]]; then
        git_ps1_cr="$cr_cyan_i"
        git_file_count="\[$git_ps1_cr\][R$renamed]\[$cr_reset\]$git_file_count"
      fi

      local added_staged="$(grep -c -s -P '^A' <<< "$git_ss")"
      if [[ "$added_staged" -ne 0 ]]; then
        git_ps1_cr="$cr_red_i"
        git_file_count="\[$git_ps1_cr\][A$added_staged]\[$cr_reset\]$git_file_count"
      fi

      local added_notstaged="$(grep -c -s -P '^\?\?' <<< "$git_ss")"
      if [[ "$added_notstaged" -ne 0 ]]; then
        git_ps1_cr="$cr_red_bg"
        git_file_count="\[$git_ps1_cr\][A$added_notstaged]\[$cr_reset\]$git_file_count"
      fi

      local deleted_staged="$(grep -c -s -P '^D' <<< "$git_ss")"
      if [[ "$deleted_staged" -ne 0 ]]; then
        git_ps1_cr="$cr_magenta_b"
        git_file_count="\[$git_ps1_cr\][D$deleted_staged]\[$cr_reset\]$git_file_count"
      fi

      local deleted_notstaged="$(grep -c -s -P '^.D' <<< "$git_ss")"
      if [[ "$deleted_notstaged" -ne 0 ]]; then
        git_ps1_cr="$cr_magenta_bg"
        git_file_count="\[$git_ps1_cr\][D$deleted_notstaged]\[$cr_reset\]$git_file_count"
      fi

      local unmerged="$(grep -c -s -P '^(.U|U.)' <<< "$git_ss")"
      if [[ "$unmerged" -ne 0 ]]; then
        git_ps1_cr="$cr_green_bg"
        git_file_count="\[$git_ps1_cr\][U$unmerged]\[$cr_reset\]$git_file_count"
      fi

      if [[ -n "$git_file_count" ]]; then
        git_file_count=" $git_file_count"
      fi
    fi

    # git summ
    local git_p="\[$git_ps1_cr\]$git_ps1\[$cr_reset\]$git_file_count $git_stash"
  else
    local git_p=""
  fi;

  # diff part
  if [[ "$last_cmd_done" -ne 1 ]]; then
    local diff_p="\[$cr_blue_i\]--:--\[$cr_reset\] "
  else
    if [[ "$last_diff_time" -le 10 ]]; then cr=$cr_green_i
    else local cr=$cr_yellow_i; fi
    local diff_p="\[$cr\]$last_diff_time_human\[$cr_reset\] "
  fi

  # NODE_ENV part
  if [[ -v NODE_ENV ]]; then
    local nodeenv_p="\[$cr_blue\]\[$cr_yellow_bg\]N:$NODE_ENV\[$cr_reset\] "
  else
    local nodeenv_p=""
  fi

  # RAILS_ENV part
  if [[ -v RAILS_ENV ]]; then
    local railsenv_p="\[$cr_blue\]\[$cr_yellow_bg\]R:$RAILS_ENV\[$cr_reset\] "
  else
    local railsenv_p=""
  fi

  # other parts
  local path_p="\[$cr_blue_i\]$(short-pwd)\[$cr_reset\] "
  local time_p="\[$cr_black_i\]$(date +%H:%M:%S)\[$cr_reset\] "

  # summ
  export PS1="$bashcount_p$diff_p$time_p$host_p$user_p$path_p$git_p$nodeenv_p$railsenv_p"
}
export PROMPT_COMMAND=prompt_command_

# Make less more friendly for non-text input files, see lesspipe(1)
[[ -x "/usr/bin/lesspipe" ]] && eval "$(SHELL=/bin/sh lesspipe)"
# Simular to git default: quit if one screen, colors, truncate lines, inline mode
export LESS="FRSX"

# Enable programmable completion features
if ! shopt -oq posix; then
  if [[ -f "/usr/share/bash-completion/bash_completion" ]]; then
    source "/usr/share/bash-completion/bash_completion"
  elif [[ -f "/etc/bash_completion" ]]; then
    source "/etc/bash_completion"
  fi
fi

# clr
if [[ -f "$HOME/.bash-tools/bash-clr" ]]; then
  source "$HOME/.bash-tools/bash-clr"
fi

# z
if [[ -f "$HOME/.bash-tools/bash-z" ]]; then
  source "$HOME/.bash-tools/bash-z"
fi

# fzf
if [[ -d "$HOME/.app/fzf/bin" ]]; then
  export PATH="$PATH:/home/nskazki/.app/fzf/bin"
  source "/home/nskazki/.app/fzf/shell/completion.bash"
  source "/home/nskazki/.app/fzf/shell/key-bindings.bash"
  source $HOME/.bash-tools/fzf.bash
  source $HOME/.bash-tools/fzf.git
  source $HOME/.bash-tools/bash.git
fi

# bash-preexec
if [[ -f "$HOME/.bash-tools/bash-preexec" ]]; then
  source "$HOME/.bash-tools/bash-preexec"

  set_title() {
    printf "\033]0;%s\007" "$1"
  }

  has_focus() {
    [[ "$(xdotool getwindowfocus)" == "$(xdotool search --name 'Guake!')" ]]
    return $?
  }

  preexec_store_cmd() {
    # store last_cmd
    export last_cmd="$1"
  }

  preexec_store_call_time() {
    # store last_call_time
    export last_call_time=$(date +%s)
  }

  preexec_ssh_to_tab() {
    # ssh -> tab
    if [[ -v COOL_TERM && "$last_cmd" =~ ^[[:space:]]*ssh[[:space:]]+ ]]; then
      local host="$(sed -r -e "s/(\s|ssh|-\w+\s*\w+|--\w+=\w+)//g" <<< "$last_cmd")"
      if [[ -n "$host" ]]; then
        set_title "$host"
      fi
    fi
  }

  precmd_check_done_time() {
    # store
    #  last_done_time
    #  last_diff_time
    #  last_diff_time_human
    #  last_cmd_done
    #  last_cmd_code
    #  check_know_call_time
    local tmp_cmd_code=$?
    if [[ "$check_know_call_time" -ne "$last_call_time" ]]; then
      export check_know_call_time="$last_call_time"
      export last_done_time="$(date +%s)"
      export last_diff_time="$((last_done_time - last_call_time))"
      export last_diff_time_human="$(human-interval $last_diff_time | sed -r -e 's/^00://')"
      export last_cmd_done=1
      export last_cmd_code="$tmp_cmd_code"
    else
      export last_cmd_done=0
    fi
  }

  precmd_print_exit_code() {
    # print exit code
    if [[ "$last_cmd_code" -ne 0 ]]; then
      echo -e "${cr_red_b}return: $last_cmd_code${cr_reset}"
    fi
  }

  precmd_pwd_to_tab() {
    # pwd -> tab-name
    # store
    #   curr_short_pwd
    #   prev_short_pwd
    if [[ -v COOL_TERM ]]; then
      export prev_short_pwd="$curr_short_pwd"
      export curr_short_pwd="$(short-pwd)"
      if [[ "$prev_short_pwd" != "$curr_short_pwd" ]]; then
        set_title "$curr_short_pwd"
      fi
    fi
  }

  precmd_show_popup() {
    # cmd -> popout
    if [[ -v COOL_TERM && "$last_cmd_done" -eq 1 ]] && ! has_focus; then
      notify-send \
        --urgency=low \
        -i "$([[ "$last_cmd_code" = 0 ]] && echo terminal || echo error)" \
        "$last_cmd"
    fi
  }

  preexec_functions+=(preexec_store_cmd)
  preexec_functions+=(preexec_store_call_time)
  preexec_functions+=(preexec_ssh_to_tab)

  precmd_functions+=(precmd_check_done_time)
  precmd_functions+=(precmd_print_exit_code)
  precmd_functions+=(precmd_pwd_to_tab)
  precmd_functions+=(precmd_show_popup)
fi

# node_modules
export PATH="node_modules/.bin:$PATH"

# yarn
if [[ -d "$HOME/.yarn/bin" ]]; then
  export PATH="$HOME/.yarn/bin:$PATH"
  source $HOME/.bash-tools/yarn-completion
fi

# npm
if [[ -n "$(which npm)" ]]; then
  export npm_config_userconfig="$HOME/.npm_auth"
  source <(npm completion)
fi

# rbenv
if [[ -d "$HOME/.rbenv/" ]]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi

# nvm
if [[ -d "$HOME/.nvm" ]]; then
  export NVM_DIR="$HOME/.nvm"
  source "$NVM_DIR/nvm.sh"
  source "$NVM_DIR/bash_completion"
fi
