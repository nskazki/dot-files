if ! status --is-interactive
  exit
end

alias rb.='rb .'
alias rc.='rc .'
alias rt.='rt .'
alias rf.='rf .'
alias rh.='rh .'
alias c.='c .'
alias f.='f .'
alias u.='u .'
alias a.='a .'
alias r.='r .'

alias rb,='rb .'
alias rc,='rc .'
alias rt,='rt .'
alias rf,='rf .'
alias rh,='rh .'
alias c,='c .'
alias f,='f .'
alias u,='u .'
alias a,='a .'
alias r,='r .'

abbr -a -- - 'cd -'
alias ...='cd ../..'

bind \cg\cf 'bound gf'
bind \cg\cb 'bound gb'
bind \cg\ct 'bound gt'
bind \cg\ch 'bound gh'
bind \cg\cr 'bound gr'

set -x LESS 'FRSX' # quit if one screen, colors, truncate lines, inline mode

set -x npm_config_userconfig ~/.npm_auth
set -ax fish_user_paths node_modules/.bin
set -ax fish_user_paths (yarn global bin)

if [ -d ~/.cargo ]
  set -ax fish_user_paths ~/.cargo/bin
end

if [ -d ~/.rbenv ]
  set -ax fish_user_paths ~/.rbenv/bin
  rbenv init - | source
end

if [ -d ~/app/fzf ]
  set -ax fish_user_paths ~/app/fzf/bin
  set -x FZF_DEFAULT_OPTS \
    "--color=dark --height 50% --ansi --reverse --no-sort --multi --preview-window right:40% \
     --bind 'ctrl-s:toggle-sort' \
     --bind 'ctrl-k:preview-up' \
     --bind 'ctrl-j:preview-down'"
end

# https://fishshell.com/docs/current/index.html?highlight=fish_color_selection#variables-for-changing-highlighting-colors

set fish_color_cancel            -r
set fish_color_comment           brblack
set fish_color_autosuggestion    brblack
set fish_color_command           normal
set fish_color_error             red
set fish_color_param             normal
set fish_color_quote             yellow
set fish_color_valid_path        cyan
set fish_color_status            red

set fish_color_normal            normal
set fish_color_history_current   --bold # the current position in the history printed by dirh
set fish_color_search_match      --background=303030 # used to highlight history search matches and the selected pager item
set fish_color_selection         --background=303030 # vi mode

set fish_color_end               blue # the color for process separators like ';' and '&'
set fish_color_escape            blue # the color used to highlight character escapes like '\n' and '\x70'
set fish_color_match             blue # the color used to highlight matching parenthesis
set fish_color_operator          blue # the color for parameter expansion operators like '*' and '~'
set fish_color_redirection       blue # the color for IO redirections

set fish_color_cwd               blue
set fish_color_cwd_root          blue
set fish_color_host              cyan
set fish_color_host_remote       cyan
set fish_color_user              magenta

set fish_pager_color_completion  normal
set fish_pager_color_description yellow
set fish_pager_color_prefix      --bold
set fish_pager_color_progress    green --background=303030
