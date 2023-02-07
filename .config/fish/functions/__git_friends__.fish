function __git_friends__ -a path pattern flags
  for hash in (git log --pretty=%H -- $path)
    for file in (git diff-tree --no-commit-id --name-only -r $hash)
      if test $file = $path
        continue
      end

      if set index (contains -i -- $file $files)
        set count[$index] (math $count[$index] + 1)
      else
        set -a count 1
        set -a files $file
      end
    end
  end

  if blank $files
    color yellow "Couldn't find any friends!"
    return 1
  end

  for index in (seq (count $files))
    set -a output "$count[$index] $files[$index]"
  end

  string join \n -- $output | sort --general-numeric-sort --reverse --key=1
end
