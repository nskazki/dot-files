function gh
  if ! __in_git_repo__
    return 1
  end

  git log --first-parent --color=always --format='%C(magenta)%h%C(auto)%d%C(reset) %s' \
    | SHELL=bash fzf --preview \
        'commit="$(echo {} | grep --color=never -o "^[a-z0-9]\{7,\}")"

         if [ -n "$commit" ]; then
           git view-commit "$commit" | ~/.scripts/diffr-with-custom-colors.sh
         fi' \
    | grep --color=never -o "^[a-f0-9]\{7,\}"
end
