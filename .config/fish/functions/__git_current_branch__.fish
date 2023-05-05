function __git_current_branch__
  set quick_branch (git rev-parse --abbrev-ref HEAD)

  if string match -q -- HEAD $quick_branch
    set branches (git branch)
    set rebase_branch (string match -g -r -- '^\* \(no branch, rebasing (.+)\)$' (git branch))

    if present $rebase_branch
      echo $rebase_branch
    else
      __git_resolve__
    end
  else
    echo $quick_branch
  end
end
