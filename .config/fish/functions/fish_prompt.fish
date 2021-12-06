function fish_prompt
  if __in_git_repo__
    set git_ps1 (bash -c '[[ -f /opt/homebrew/etc/bash_completion.d/git-prompt.sh ]] && source /opt/homebrew/etc/bash_completion.d/git-prompt.sh || source /etc/bash_completion.d/git-prompt;  __git_ps1 %s')
    set git_ps1_cr green

    if string match (basename $PWD) '.git'
      set git_ps1_cr --background yellow
    else if string match (git rev-parse --is-bare-repository) 'true'
      set git_ps1_cr --background green
    else
      set stash_list (git stash list | wc -l)
      set status_short (git -c color.status=never status -s)

      # git_stash
      if [ "$stash_list" -ne 0 ]
        set git_stash (set_color yellow)'stash['$stash_list']'(set_color normal)
      end

      # modified_staged
      set modified_staged (string match -r '^M' $status_short | wc -l)
      if [ "$modified_staged" -ne 0 ]
        set git_ps1_cr blue --bold
        set -p git_files (set_color $git_ps1_cr)'[M'$modified_staged']'(set_color normal)
      end

      # modified
      set modified (string match -r '^.M' $status_short | wc -l)
      if [ "$modified" -ne 0 ]
        set git_ps1_cr --background blue
        set -p git_files (set_color $git_ps1_cr)'[M'$modified']'(set_color normal)
      end

      # renamed
      set renamed (string match -r '^R' $status_short | wc -l)
      if [ "$renamed" -ne 0 ]
        set git_ps1_cr cyan --bold
        set -p git_files (set_color $git_ps1_cr)'[R'$renamed']'(set_color normal)
      end

      # added_staged
      set added_staged (string match -r '^A' $status_short | wc -l)
      if [ "$added_staged" -ne 0 ]
        set git_ps1_cr red --bold
        set -p git_files (set_color $git_ps1_cr)'[A'$added_staged']'(set_color normal)
      end

      # added
      set added (string match -r '^\\?\\?' $status_short | wc -l)
      if [ "$added" -ne 0 ]
        set git_ps1_cr --background red
        set -p git_files (set_color $git_ps1_cr)'[A'$added']'(set_color normal)
      end

      # deleted_staged
      set deleted_staged (string match -r '^D' $status_short | wc -l)
      if [ "$deleted_staged" -ne 0 ]
        set git_ps1_cr magenta --bold
        set -p git_files (set_color $git_ps1_cr)'[D'$deleted_staged']'(set_color normal)
      end

      # deleted
      set deleted (string match -r '^.D' $status_short | wc -l)
      if [ "$deleted" -ne 0 ]
        set git_ps1_cr --bold --background magenta
        set -p git_files (set_color $git_ps1_cr)'[D'$deleted']'(set_color normal)
      end

      # unmerged
      set unmerged (string match -r '^(?:.U|U.)' $status_short | wc -l)
      if [ "$unmerged" -ne 0 ]
        set git_ps1_cr --background green
        set -p git_files (set_color $git_ps1_cr)'[U'$unmerged']'(set_color normal)
      end
    end

    set git_ps1 (set_color $git_ps1_cr)$git_ps1(set_color normal)
    set git_files (string join '' $git_files)
  end

  if [ "$SHLVL" -gt 1 ]
    set level (set_color magenta)fish#$SHLVL(set_color normal)
  end

  set pwd (set_color blue)(prompt_pwd)(set_color normal)

  if present $NODE_ENV
    set nodeenv (set_color blue --background yellow)N:$NODE_ENV(set_color normal)
  end

  if present $RAILS_ENV
    set railsenv (set_color blue --background yellow)N:$RAILS_ENV(set_color normal)
  end

  set -a output $level
  set -a output $pwd
  set -a output $git_ps1
  set -a output $git_files
  set -a output $git_stash
  set -a output $nodeenv
  set -a output $railsenv
  set -a output ''

  echo $output
end
