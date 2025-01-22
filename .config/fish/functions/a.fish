function a
  if ! __git_has_stageable__
    color yellow 'nothing to do!'
    return 1
  end

  if [ "$argv" = '.' ]
    set paths (__git_stageable_list__)
  else if present $argv
    set paths $argv
  else
    set paths (gf)
  end

  if blank $paths
    color blue 'nothing to add!'
    return 1
  end

  echo
  for path in $paths
    if present $path
      echo (color brblack '$') 'git add -f --' (color yellow $path)
      git add -f -- $path || return $status
    end
  end

  __git_status__
end
