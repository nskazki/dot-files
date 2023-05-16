function gh
  if ! __in_git_repo__
    return 1
  end

  if present $argv
    for arg in $argv
      for commit in (git log --first-parent -n10 --no-merges --pretty=%h -- $arg)
        set -e commit_index
        if set -q commits
          set commit_index (contains -i $commit $commits)
        end

        if present $commit_index
          set counts[$commit_index] (math $counts[$commit_index] + 1)
        else
          set -a counts 1
          set -a commits $commit
        end
      end
    end
  end

  set logs (git log --first-parent -n100 --color=always --format='%C(magenta)%h%C(auto)%d%C(reset) %s')

  if present $commits
    set commit_pattern '^.\[\d+m([a-z0-9]{7,}).\[m'
    set opening_bracket (color yellow \()
    set closing_bracket (color yellow \))

    for log_index in (seq (count $logs))
      set log $logs[$log_index]
      set log_commit (string match -r -g -- $commit_pattern $log)
      set commit_index (contains -i $log_commit $commits)

      if present $commit_index
        set count $counts[$commit_index]
        set marker "$opening_bracket"(color blue (string repeat -n $count '*'))"$closing_bracket"
        set logs[$log_index] (string replace -r -- $commit_pattern "\$0 $marker" $log)
      end
    end
  end

  string collect -- $logs \
    | SHELL=bash fzf --preview \
        'commit="$(echo {} | grep --color=never -o "^[a-z0-9]\{7,\}")"

         if [ -n "$commit" ]; then
           git view-commit "$commit" | ~/.scripts/diffr-with-custom-colors.sh
         fi' \
    | grep --color=never -o "^[a-f0-9]\{7,\}"
end
