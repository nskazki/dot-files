function gh
  if ! __in_git_repo__
    return
  end

  git log --graph --color=always --format='%C(magenta)%h%C(auto)%d%C(reset) %s' \
    | SHELL=bash fzf --preview \
        'commit="$(echo {} | grep -Eo " [a-z0-9]+ " | head -n 1 | sed "s/ //g")"

         if [ -n "$commit" ]; then
           git view-commit "$commit"
         fi' \
    | grep --color=never -o "[a-f0-9]\{7,\}"
end
