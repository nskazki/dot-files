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
alias t.='t .'
alias e.='e .'

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
alias t,='t .'
alias e,='e .'

abbr -a -- - 'cd -'
alias ...='cd ../..'

bind \cg\cf 'bound gf'
bind \cg\cb 'bound gb'
bind \cg\ct 'bound gt'
bind \cg\ch 'bound gh'
bind \cg\cr 'bound gr'
bind \cg\cl 'bound gl'
bind \cg\cm 'bound gm'
bind \cr 'search-history'

set -x LESS FRSX # quit if one screen, colors, truncate lines, inline mode

set -x EDITOR micro
set -x VISUAL subl

set -x LANG en_US.UTF-8
set -x LC_COLLATE C

set -x HOMEBREW_NO_AUTO_UPDATE 1
set -x HUSKY 0

# https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
set -x TZ_LIST 'US/Pacific; UTC; GMT; Europe/Lisbon,Portugal; CET; Europe/Belgrade,Belgrade; Europe/Moscow,Moscow; Asia/Jakarta,Jakarta; Australia/Melbourne,Melbourne'

if [ -d /opt/homebrew/bin/brew ]
  eval (/opt/homebrew/bin/brew shellenv)
end

if [ -d ~/.cargo ]
  fish_add_path ~/.cargo/bin
end

if [ -d ~/go ]
  fish_add_path ~/go/bin
end

if [ -d ~/.rbenv ]
  fish_add_path ~/.rbenv/bin
end

if [ -d /Applications/Postgres.app/Contents/Versions/latest ]
  fish_add_path /Applications/Postgres.app/Contents/Versions/latest/bin
end

if [ -d /Volumes/Repos/tz ]
  fish_add_path /Volumes/Repos/tz
end

if [ -d /opt/homebrew/opt/node@22 ]
  fish_add_path /opt/homebrew/opt/node@22/bin
end

if command -v rbenv > /dev/null
  rbenv init - fish | source
end

if command -v fzf > /dev/null
  set -x FZF_DEFAULT_OPTS \
    "--color=dark --height 50% --ansi --reverse --no-sort --multi --preview-window right:40% \
     --bind 'ctrl-k:preview-up' \
     --bind 'ctrl-j:preview-down'"
end

if command -v node > /dev/null
  set -x npm_config_userconfig $HOME/.npm_auth
end

if command -v direnv > /dev/null
  direnv hook fish | source
end

if command -v zoxide > /dev/null
  zoxide init fish | source
end

if [ -d ~/.bun ]
  set -x BUN_INSTALL $HOME/.bun
  fish_add_path ~/.bun/bin
end

if [ -f ~/.iterm2_shell_integration.fish ]
  source ~/.iterm2_shell_integration.fish
end

if [ -f ~/.scripts/kill_lonely_webpack_postexec.fish ]
  source ~/.scripts/kill_lonely_webpack_postexec.fish
end

if [ -f ~/.asdf/asdf.fish ]
  source ~/.asdf/asdf.fish
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

