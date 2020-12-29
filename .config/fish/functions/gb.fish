function gb
  if ! __in_git_repo__
    return
  end

  git branch -a --color=always \
    | string match -vr '\\bHEAD\\W' \
    | SHELL=bash fzf --preview-window right:70% --preview 'git log-hist -n 100 $(echo {} | cut -c 3- | cut -d" " -f1)' \
    | string sub -s 3 \
    | string match -r '^.*?(?:\s|$)' \
    | string replace -r '^remotes/(?:origin|upstream)/' ''
end
