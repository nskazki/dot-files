function f
  if ! __in_git_repo__
    return 1
  end

  if ! __git_dirty__
    color yellow 'nothing to do!'
    return 1
  end

  if [ "$argv" = '.' ]
    set paths (__git_stageable_list__)
  else if ! __git_has_staged__
    set paths (gf)
  end

  if ! __git_has_staged__ && blank $paths
    color blue 'nothing to commit!'
    return 1
  end

  if [ "$argv" = '.' ]
    set commit HEAD
  else if present $argv
    set commit $argv
  else
    set commit (gh (__git_relative_path__ $paths (__git_staged_list__)))
  end

  if blank $commit
    color blue 'target is not selected!'
    return 1
  end

  if ! string match -- 1 (count $commit)
    color red 'cannot process several targets!'
    return 1
  end

  echo
  for path in $paths
    if present $path
      echo (color brblack '$') 'git add -f --' (color yellow $path)
      git add -f -- (git root)/$path || return $status
    end
  end

  echo (color brblack '$') 'git commit --quiet --fixup' (color cyan $commit)
  git commit --quiet --fixup $commit || return $status

  __git_show__
end
