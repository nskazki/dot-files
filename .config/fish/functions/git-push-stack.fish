function git-push-stack -a target_branch base_branch
  if ! __in_git_repo__
    return 1
  end

  set branch_stack (__git_stack__ $target_branch $base_branch)

  if blank $branch_stack
    color blue 'nothing to push!'
    return 1
  end

  echo
  echo (color brblack '$') 'git push --atomic --force-with-lease' (color magenta origin) \\
  string split -n ' ' -- $branch_stack | string replace -r '^' \t | color green | string join -- ' \\'\n
  echo

  git push --atomic --force-with-lease origin $branch_stack
end
