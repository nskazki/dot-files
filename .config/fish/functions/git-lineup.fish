function git-lineup
  if ! __in_git_repo__
    return 1
  end

  set line_branch (__git_current_branch__)
  set orig_branch (__git_clean_line__ $line_branch)

  if ! string match -r -q -- '^__line__' $line_branch
    color red 'current branch is not a line branch!'
    return 1
  end

  set good_resolutions (find (git git-dir)/rr-cache -type d -depth 1)

  while true
    set picked_commit (__git_resolve__ CHERRY_PICK_HEAD)
    if blank $picked_commit
      break
    end

    if ! __git_dirty__
      echo (color brblack '$') 'git cherry-pick --skip'
      GIT_HOOKS=0 git cherry-pick --skip >/dev/null 2>&1
      continue
    end

    set conflicts (git diff --name-only --diff-filter=U | __git_root_relative__)

    if present $conflicts
      echo (color brblack '$') 'git checkout ' (color cyan $picked_commit) -- (color yellow $conflicts)
      echo (color brblack '$') (color magenta 'GIT_HOOKS=0') (color magenta 'GIT_EDITOR=/usr/bin/true') 'git cherry-pick --continue'

      git checkout $picked_commit -- $conflicts || return $status
      GIT_HOOKS=0 GIT_EDITOR=/usr/bin/true git cherry-pick --continue >/dev/null 2>&1
    else
      set abort
      echo
      echo "Run 'git-lineup' after dealing with $(__git_inline_info__ CHERRY_PICK_HEAD)"
      echo
      break
    end
  end

  for resolution in (find (git git-dir)/rr-cache -type d -depth 1)
    if ! contains $resolution $good_resolutions
      echo (color brblack '$') rm -r -- (color yellow $resolution)
      rm -r -- $resolution
    end
  end

  if ! set -q abort && present (git diff $orig_branch..$line_branch)
    echo
    color yellow "$orig_branch != $line_branch"
    echo
    git diff $orig_branch..$line_branch
    return 1
  end
end
