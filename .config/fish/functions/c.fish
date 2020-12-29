function c
  if ! __git_dirty__
    color yellow 'nothing to do!'
    return 1
  end

  echo
  set paths (__git_stageable_list__)
  for path in $paths
    if present $path
      echo (color brblack '$') 'git add -f --' (color yellow $path)
      git add -f -- (git root)/$path || return $status
    end
  end

  set last (git log --format='%s' -n1 HEAD | string replace -r '^(fixup! )+' '' | string match -r '^[[:digit:]]+$')
  if present $last
    set next (math 1 + $last)
  else
    set next 1
  end

  echo (color brblack '$') 'git commit -m' (color cyan $next)
  git commit --quiet -m $next || return $status

  __git_show__
end
