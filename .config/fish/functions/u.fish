function u
  if ! __in_git_repo__
    return 1
  end

  if ! __git_has_staged__
    color yellow 'nothing to do!'
    return 1
  end

  if [ "$argv" = '.' ]
    set paths (__git_staged_list__)
  else if present $argv
    set paths $argv
  else
    set paths (gf)
  end

  if blank $paths
    color blue 'nothing to unstage!'
    return 1
  end

  echo
  for path in $paths
    if present $path
      echo (color brblack '$') 'git unstage' (color yellow $path)
      git unstage $path > /dev/null || return $status
    end
  end

  __git_status__
end
