function rc
  if ! __in_git_repo__
    return 1
  end

  if [ "$argv" = '.' ]
    set paths (__git_stageable_list__)
  end

  echo
  for path in $paths
    if present $path
      echo (color brblack '$') 'git add -f --' (color yellow $path)
      git add -f -- $path || return $status
    end
  end

  echo (color brblack '$') 'git recommit'
  git commit --amend --quiet || return $status

  __git_show__
end
