function gt
  if ! __in_git_repo__
    return
  end

  git tag --sort -version:refname | SHELL=bash fzf --preview-window right:70% --preview 'git show --color=always {}'
end
