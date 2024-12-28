function fish_prompt
  if __in_git_repo__
    set git_ps1 (bash -c '[[ -f /opt/homebrew/etc/bash_completion.d/git-prompt.sh ]] && source /opt/homebrew/etc/bash_completion.d/git-prompt.sh || source /etc/bash_completion.d/git-prompt;  __git_ps1 %s')
    set git_ps1_cr green

    if string match (basename $PWD) '.git'
      set git_ps1_cr black --background yellow
    else if string match (git rev-parse --is-bare-repository) 'true'
      set git_ps1_cr black --background green
    else
      set stash_list (git stash list | count)
      set status_short (git status -s --porcelain)

      # git_stash
      if test "$stash_list" -ne 0
        set git_stash (set_color yellow)'stash['$stash_list']'(set_color normal)
      end

      # modified_staged
      set modified_staged (string match -r '^M[^U]' $status_short | count)
      if test "$modified_staged" -ne 0
        set git_ps1_cr blue --bold
        set -p git_files (set_color $git_ps1_cr)'[M'$modified_staged']'(set_color normal)
      end

      # modified
      set modified (string match -r '^[^U]M' $status_short | count)
      if test "$modified" -ne 0
        set git_ps1_cr black --background blue
        set -p git_files (set_color $git_ps1_cr)'[M'$modified']'(set_color normal)
      end

      # renamed
      set renamed (string match -r '^R[^U]' $status_short | count)
      if test "$renamed" -ne 0
        set git_ps1_cr cyan --bold
        set -p git_files (set_color $git_ps1_cr)'[R'$renamed']'(set_color normal)
      end

      # added_staged
      set added_staged (string match -r '^A[^U]' $status_short | count)
      if test "$added_staged" -ne 0
        set git_ps1_cr red --bold
        set -p git_files (set_color $git_ps1_cr)'[A'$added_staged']'(set_color normal)
      end

      # added
      set added (string match -r '^\\?\\?' $status_short | count)
      if test "$added" -ne 0
        set git_ps1_cr black --background red
        set -p git_files (set_color $git_ps1_cr)'[A'$added']'(set_color normal)
      end

      # deleted_staged
      set deleted_staged (string match -r '^D[^U]' $status_short | count)
      if test "$deleted_staged" -ne 0
        set git_ps1_cr magenta --bold
        set -p git_files (set_color $git_ps1_cr)'[D'$deleted_staged']'(set_color normal)
      end

      # deleted
      set deleted (string match -r '^[^U]D' $status_short | count)
      if test "$deleted" -ne 0
        set git_ps1_cr black --background magenta
        set -p git_files (set_color $git_ps1_cr)'[D'$deleted']'(set_color normal)
      end

      # unmerged
      set unmerged (string match -r '^(?:.U|U.)' $status_short | count)
      if test "$unmerged" -ne 0
        set git_ps1_cr black --background green
        set -p git_files (set_color $git_ps1_cr)'[U'$unmerged']'(set_color normal)
      end
    end

    set git_ps1 (set_color $git_ps1_cr)$git_ps1(set_color normal)
    set git_files (string join '' $git_files)
  end

  if test "$SHLVL" -gt 1
    set level (set_color magenta)fish#$SHLVL(set_color normal)
  end

  set pwd (set_color blue)(prompt_pwd)(set_color normal)

  set -a output $level
  set -a output $pwd
  set -a output $git_ps1
  set -a output $git_files
  set -a output $git_stash
  set -a output ''

  echo $output
end
