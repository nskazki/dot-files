function r
  if ! __git_has_untracked__
    color yellow 'nothing to do!'
    return 1
  end

  if [ "$argv" = '.' ]
    set paths (__git_untracked_list__)
  else if present $argv
    set paths $argv
  else
    set paths (__git_untracked_list__ | SHELL=bash fzf --multi --preview 'cat {}')
  end

  if blank $paths
    color blue 'nothing to remove!'
    return 1
  end

  echo
  for path in $paths
    if present $path
      echo (color brblack '$') 'gio trash -f --' (color red $path)
      gio trash -f -- (git root)/$path || return $status
    end
  end

  __git_status__
end
