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

# Detect TerminalView
if [ -z "$TERM_VIEW" ]; then
  if [[ "$(get-parent-name)" == "plugin_host" ]];
  then export TERM_VIEW=1;
  else export TERM_VIEW=0; fi
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

if [ "$TERM_VIEW" -eq 0 ]; then
  cr_black_i="\e[0;90m"
  cr_red_i="\e[0;91m"
  cr_green_i="\e[0;92m"
  cr_yellow_i="\e[0;93m"
  cr_blue_i="\e[0;94m"
  cr_magenta_i="\e[0;95m"
  cr_cyan_i="\e[0;96m"
  cr_white_i="\e[0;97m"
else
  cr_black_i="\e[0;30m"
  cr_red_i="\e[0;31m"
  cr_green_i="\e[0;32m"
  cr_yellow_i="\e[0;33m"
  cr_blue_i="\e[0;34m"
  cr_magenta_i="\e[0;35m"
  cr_cyan_i="\e[0;36m"
  cr_white_i="\e[0;37m"
fi

# Promt helpers
export HOST="$HOSTNAME"
export HIAM="(xyn|eevee)"
export UIAM="nskazki"

if [[ -n "$(echo "$HOST" | grep --perl-regexp "$HIAM")" ]];
then export HOST_IAM=1 && export HOST_OTHER=0;
else export HOST_OTHER=1 && export HOST_IAM=0; fi

if [[ -n "$(echo "$USER" | grep -s "$UIAM")" ]];
then export USER_IAM=1 && export USER_OTHER=0;
else export USER_OTHER=1 && export USER_IAM=0; fi

# Promt

# bash_count part
bash_count=$(count-bash-tree)
if [ $bash_count -eq 1 ]; then bashcount_p=""
else bashcount_p="\[$cr_magenta_i\]bash#$bash_count\[$cr_reset\] "; fi

# host part
if [ $HOST_IAM -eq 1 ]; then cr_host=$cr_cyan_i
else cr_host=$cr_cyan_bg; fi
host_p="\[$cr_host\]$HOST\[$cr_reset\] "

# user part
if [ $UID -eq 0 ]; then user_p="\[$cr_red_bg\]$USER\[$cr_reset\] ";
elif [ $USER_OTHER -eq 1 ]; then user_p="\[$cr_red_i\]$USER\[$cr_reset\] ";
elif [ $USER_IAM -eq 1 ]; then user_p=""; fi

# exports
export check_know_call_time=0
export last_call_time=0
export last_done_time=0
export last_diff_time=0
export last_diff_time_human=""
export last_exec_done=0
export last_result=0
export curr_short_pwd
export prev_short_pwd


prompt_command_() {
  # sync history
  history -a
  history -c
  history -r

  # git part
  if [ -n "$(git branch 2>/dev/null)" ] && (type __git_ps1 > /dev/null);
  then local repo=1;
  else local repo=0; fi

  if [ $repo -eq 1 ]; then
    local git_ps1="$(__git_ps1 '%s')"
    local git_ps1_cr="$cr_green_i"
    local git_file_count=""
    local git_stash=""

    if [ "$(basename "$PWD")" == ".git" ]; then git_ps1_cr="$cr_yellow_bg";
    elif [ "$(git rev-parse --is-bare-repository)" == "true" ]; then git_ps1_cr="$cr_green_bg"
    else
      # git_stash
      local git_sl="$(git stash list | wc -l)"
      if [ $git_sl -ne 0 ]; then
        git_stash="\[$cr_yellow_i\]stash[$git_sl]\[$cr_reset\] "
      fi

      # git_ps1_cr & git_file_count
      local git_ss="$(git status -s)"

      local modified_staged=$(echo "$git_ss" | grep -c -s -P '^M')
      if [ $modified_staged -ne 0 ]; then
        git_ps1_cr=$cr_blue_b
        git_file_count="\[$git_ps1_cr\][M$modified_staged]\[$cr_reset\]$git_file_count"
      fi

      local modified_notstaged=$(echo "$git_ss" | grep -c -s -P '^.M')
      if [ $modified_notstaged -ne 0 ]; then
        git_ps1_cr=$cr_blue_bg
        git_file_count="\[$git_ps1_cr\][M$modified_notstaged]\[$cr_reset\]$git_file_count"
      fi

      local renamed=$(echo "$git_ss" | grep -c -s -P '^R')
      if [ $renamed -ne 0 ]; then
        git_ps1_cr=$cr_cyan_i
        git_file_count="\[$git_ps1_cr\][R$renamed]\[$cr_reset\]$git_file_count"
      fi

      local added_staged=$(echo "$git_ss" | grep -c -s -P '^A')
      if [ $added_staged -ne 0 ]; then
        git_ps1_cr=$cr_red_i
        git_file_count="\[$git_ps1_cr\][A$added_staged]\[$cr_reset\]$git_file_count"
      fi

      local added_notstaged=$(echo "$git_ss" | grep -c -s -P '^\?\?')
      if [ $added_notstaged -ne 0 ]; then
        git_ps1_cr=$cr_red_bg
        git_file_count="\[$git_ps1_cr\][A$added_notstaged]\[$cr_reset\]$git_file_count"
      fi

      local deleted_staged=$(echo "$git_ss" | grep -c -s -P '^D')
      if [ $deleted_staged -ne 0 ]; then
        git_ps1_cr=$cr_magenta_b
        git_file_count="\[$git_ps1_cr\][D$deleted_staged]\[$cr_reset\]$git_file_count"
      fi

      local deleted_notstaged=$(echo "$git_ss" | grep -c -s -P '^.D')
      if [ $deleted_notstaged -ne 0 ]; then
        git_ps1_cr="$cr_magenta_bg"
        git_file_count="\[$git_ps1_cr\][D$deleted_notstaged]\[$cr_reset\]$git_file_count"
      fi

      local unmerged=$(echo "$git_ss" | grep -c -s -P '^(.U|U.)')
      if [ $unmerged -ne 0 ]; then
        git_ps1_cr=$cr_green_bg
        git_file_count="\[$git_ps1_cr\][U$unmerged]\[$cr_reset\]$git_file_count"
      fi

      if [ -n "$git_file_count" ]; then
        git_file_count=" $git_file_count"
      fi
    fi

    # git summ
    local git_p="\[$git_ps1_cr\]$git_ps1\[$cr_reset\]$git_file_count $git_stash"
  else
    local git_p=""
  fi;

  # diff part
  if [ $last_exec_done -ne 1 ]; then
    local diff_p="\[$cr_blue_i\]--:--\[$cr_reset\] "
  else
    if [ $last_diff_time -le 10 ]; then cr=$cr_green_i
    else local cr=$cr_yellow_i; fi
    local diff_p="\[$cr\]$last_diff_time_human\[$cr_reset\] "
  fi

  # NODE_ENV part
  if [ -n "$NODE_ENV" ]; then
    local nodeenv_p="\[$cr_blue_bg\]$NODE_ENV\[$cr_reset\] "
  else
    local nodeenv_p=""
  fi

  # other parts
  local path_p="\[$cr_blue_i\]$(short-pwd)\[$cr_reset\] "
  local time_p="\[$cr_black_i\]$(date +%H:%M:%S)\[$cr_reset\] "

  # summ
  export PS1="$bashcount_p$diff_p$time_p$host_p$user_p$path_p$git_p$nodeenv_p"
}
export PROMPT_COMMAND=prompt_command_

# Make less more friendly for non-text input files, see lesspipe(1)
[ -x "/usr/bin/lesspipe" ] && eval "$(SHELL=/bin/sh lesspipe)"
# Simular to git default: quit if one screen, colors, truncate lines, inline mode
export LESS="FRSX"

# Set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r "/etc/debian_chroot" ]; then
  export debian_chroot="$(cat /etc/debian_chroot)"
fi

# Enable programmable completion features
if ! shopt -oq posix; then
  if [ -f "/usr/share/bash-completion/bash_completion" ]; then
    source "/usr/share/bash-completion/bash_completion"
  elif [ -f "/etc/bash_completion" ]; then
    source "/etc/bash_completion"
  fi
fi

# Find ssh agent
if [ -f "$HOME/.bash-tools/bash-ssh-find-agent" ]; then
  source "$HOME/.bash-tools/bash-ssh-find-agent"
  ssh-find-agent -a || eval $(ssh-agent)
fi

# clr
if [ -f "$HOME/.bash-tools/bash-clr" ]; then
  source "$HOME/.bash-tools/bash-clr"
fi

# z
if [ -f "$HOME/.bash-tools/bash-z" ]; then
  source "$HOME/.bash-tools/bash-z"
fi

# even-better-ls
if [ -n "$(which ls-i)" ]; then
  source "$HOME/.bash-tools/setup-better-ls"
fi

# fzf
if [[ -d "$HOME/.app/fzf/bin" ]]; then
  export PATH="$PATH:/home/nskazki/.app/fzf/bin"
  source $HOME/.bash-tools/fzf.bash
  source $HOME/.bash-tools/fzf.git
  source $HOME/.bash-tools/bash.git
fi

# bash-preexec
if [ -f "$HOME/.bash-tools/bash-preexec" ]; then
  source "$HOME/.bash-tools/bash-preexec"

  preexec_store_call_time() {
    # store last_call_time
    export last_call_time=$(date +%s)
  }

  preexec_ssh_to_tab() {
    (_preexec_ssh_to_tab "$1" &) > /dev/null 2>&1
  }


  _preexec_ssh_to_tab() {
    # ssh-host -> tab-name
    if [ -n "$GUAKE_TAB_UUID" ] && [ -n "$(echo "$1" | grep -P -s "^\s*ssh\s+")" ]; then
      local host=$(echo "$1" | sed -r -e "s/(\s|ssh|-\w+\s*\w+|--\w+=\w+)//g")
      if [ -n "$host" ]; then
        guake --rename-tab="$host" --tab-index="$GUAKE_TAB_UUID"
      fi
    fi
  }

  precmd_check_done_time() {
    # store
    #  last_done_time
    #  last_diff_time
    #  last_diff_time_human
    #  last_exec_done
    #  check_know_call_time
    if [ $check_know_call_time -ne $last_call_time ]; then
      export check_know_call_time=$last_call_time
      export last_done_time=$(date +%s)
      export last_diff_time=$((last_done_time - last_call_time))
      export last_diff_time_human="$(human-interval $last_diff_time | sed -r -e 's/^00://')"
      export last_exec_done=1
    else
      export last_exec_done=0
    fi
  }

  precmd_print_exit_code() {
    # exit code print
    # store last_result
    local test_last_result=$?
    if [ $last_exec_done -eq 1 ]; then
      export last_result=$test_last_result
      if [ $last_result -ne 0 ]; then
        echo -e "${cr_red_b}return: $last_result${cr_reset}"
      fi
    fi
  }

  precmd_pwd_to_tab() {
    (_precmd_pwd_to_tab &) > /dev/null 2>&1
  }

  _precmd_pwd_to_tab() {
    # quake tab name
    # pwd -> tab-name
    # store
    #   curr_short_pwd
    #   prev_short_pwd
    if [ -n "$GUAKE_TAB_UUID" ]; then
      export prev_short_pwd="$curr_short_pwd"
      export curr_short_pwd="$(short-pwd)"
      if [ "$prev_short_pwd" != "$curr_short_pwd" ]; then
        guake --rename-tab="$curr_short_pwd" --tab-index="$GUAKE_TAB_UUID"
      fi
    fi
  }

  precmd_show_popup() {
    (_precmd_show_popup &) > /dev/null 2>&1
  }

  _precmd_show_popup() {
    # exit cmd popup
    local result="$?"
    local gs_path="$HOME/.guake-state"

    if [ -n "$GUAKE_TAB_UUID" ] &&
       [ $last_exec_done -eq 1 ] &&
       [ -f "$gs_path" ] &&
       [ "$(cat "$gs_path")" ==  "hide" ];
    then
      notify-send \
        --urgency=low \
        -t 1000 \
        -i "$([ $result = 0 ] && echo terminal || echo error)" \
        "$(history | tail -n1 | sed -r 's/^\s*[0-9]+\s*//g')"
    fi
  }

  precmd_send_talert() {
    (_precmd_send_talert &) > /dev/null 2>&1
  }

  _precmd_send_talert() {
    if [ $HOST_OTHER -eq 1 ] &&
       [ $last_exec_done -eq 1 ] &&
       [ $last_diff_time -ge 10 ] &&
       (type talert > /dev/null 2>&1);
    then
      talert
    fi
  }

  preexec_functions+=(preexec_store_call_time)
  preexec_functions+=(preexec_ssh_to_tab)

  precmd_functions+=(precmd_check_done_time)
  precmd_functions+=(precmd_print_exit_code)
  precmd_functions+=(precmd_show_popup)
  precmd_functions+=(precmd_pwd_to_tab)
  precmd_functions+=(precmd_send_talert)
fi

# node_modules
if [[ "$HOST_IAM" == 1 ]]; then
  export PATH="node_modules/.bin:$PATH"
fi

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
if [ -d "$HOME/.rbenv/" ]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi

# nvm
if [ -d "$HOME/.nvm" ]; then
  export NVM_DIR="$HOME/.nvm"
  source "$NVM_DIR/nvm.sh"
  source "$NVM_DIR/bash_completion"
fi
