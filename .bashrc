# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
test -z "$PS1" && return

export LESS="FRSX"

# http://habrahabr.ru/post/198482/
export HISTCONTROL='ignoreboth:ignoredups:ignorespace:erasedups'
export HISTSIZE=-1
export HISTFILESIZE=10000

# Append to the history file, don't overwrite it
shopt -s histappend

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# turn on dot files
shopt -s dotglob

bind 'set completion-ignore-case on'
bind 'set completion-map-case on'
bind 'set completion-query-items -1'
bind 'set show-all-if-ambiguous on'
bind 'set show-all-if-unmodified on'
bind 'set page-completions off'
bind 'set match-hidden-files on'
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

if ! shopt -oq posix; then
  if [[ -f "/usr/share/bash-completion/bash_completion" ]]; then
    source "/usr/share/bash-completion/bash_completion"
  elif [[ -f "/etc/bash_completion" ]]; then
    source "/etc/bash_completion"
  fi
fi
