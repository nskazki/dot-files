function git-redate
  if present $argv
    set commit $argv
  else
    set commit (gh)
  end

  if blank $commit
    color blue 'nothing to redate!'
    return 1
  end

  set format (echo -e 'author\ncommit' \
                | SHELL=bash fzf --preview \
                    "if [ '{1}' = 'author' ]; then
                       git log --format='%ad' --date=format:'%Y-%m-%d %H:%M' $commit^..HEAD | sort -r
                     else
                       git log --format='%cd' --date=format:'%Y-%m-%d %H:%M' $commit^..HEAD | sort -r
                     fi")

  if blank $format
    color blue 'format is not defined!'
    return 1
  end

  set commits (git log --format='%H' $commit^..HEAD)

  if string match -q $format 'author'
    set dates (git log --format='%ad' --date=format:'%Y-%m-%d %H:%M' $commit^..HEAD | sort -r)
  else
    set dates (git log --format='%cd' --date=format:'%Y-%m-%d %H:%M' $commit^..HEAD | sort -r)
  end

  for index in (seq (count $commits))
    set -l date $dates[$index]
    set -l commit $commits[$index]

    if string match -q $index '1'
      set filter " if"
    else
      set -a filter "\n elif"
    end

    set -a filter "[ \$GIT_COMMIT = $commit ]; then \
                 \n   GIT_AUTHOR_DATE='$date'; \
                 \n   GIT_COMMITTER_DATE='$date'; \
                 \n   git commit-tree \$@;"
  end

  set -a filter "\n else \
                 \n   git commit-tree \$@; \
                 \n fi"

  set filter (echo -e "$filter" | string collect)

  echo $filter

  FILTER_BRANCH_SQUELCH_WARNING=1 git filter-branch -f --commit-filter "$filter" $commit^..HEAD
end
