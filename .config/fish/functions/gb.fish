function gb
  if ! __in_git_repo__
    return
  end

  git branch -a --color=always \
    | string match -vr "\bHEAD\W|\(no branch," \
    | SHELL=bash fzf --preview-window right:70% --preview 'git log-hist -n 100 $(echo {} | cut -c 3- | cut -d" " -f1)' \
    | cut -c 3- | cut -d" " -f1 \
    | string replace -r "^remotes/[^/]+/" ''
end
