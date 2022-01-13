function rb
  if [ "$argv" = '.' ]
    set messages (__git_fixup_targets__)
    if blank $messages
      color yellow 'nothing to do!'
      return 1
    end

    for message in $messages
      if present $message
        set commit (git log --format='%h' -n1 --grep \^$message\$)
        if blank $commit
          color red 'cannot find the target commit by' $message
          return 1
        else
          set -a commits $commit
        end
      end
    end

    set most_distant_commit (__git_most_distant_commit__ $commits)
    if blank $most_distant_commit
      color red 'cannot find the most distant commit'
      return 1
    end

    echo
    echo (color brblack '$') (color magenta 'GIT_SEQUENCE_EDITOR=/usr/bin/true') 'git rebase -i' (color cyan $most_distant_commit)^
    echo
    GIT_SEQUENCE_EDITOR=/usr/bin/true git rebase --autosquash -i $most_distant_commit^ || return $status
    echo
  else
    if present $argv
      set commit $argv
    else
      set commit (gh)
    end

    if blank $commit
      color blue input was interrupted!
      return 1
    end

    echo
    echo (color brblack '$') 'git rebase -i' (color cyan $commit)^
    echo
    git rebase -i $commit^ || return $status
    echo
  end
end
