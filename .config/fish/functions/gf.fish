function gf
  if ! __in_git_repo__
    return
  end

  git -c color.status=always status --short \
    | string unescape \
    | SHELL=bash fzf --preview \
        'part="$(sed "s/.* -> //" <<< {2..-1})"
         file="$(git root)/$part"

         red="\e[1;41m"
         blue="\e[1;44m"
         white="\e[0;94m\e[1;107m"
         reset="\e[0m"

         if [ -n "$(file --mime -- "$file" | grep binary)" ]; then
           echo "binary file"
         else
          if [ -n "$(git diff -- "$file")" ]; then
            echo -e "$blue    MODIFIED    $reset"
            git diff --color=always -- "$file" | sed 1,4d
          fi

          if [ -n "$(git diff --staged -- "$file")" ]; then
            echo -e "$white     STAGED     $reset"
            if [ {1} == "A" ]; then
              git diff --staged --color=always -- "$file" | sed 1,5d
            else
              git diff --staged --color=always -- "$file" | sed 1,4d
            fi
          fi

          if [ -z "$(git diff -- "$file")" ] && [ -z "$(git diff --staged -- "$file")" ] && [ -n "$(cat -- "$file")" ]; then
            echo -e "$red    UNTRACKED    $reset"
            cat -- "$file" | head -n 1000
          fi
         fi' \
    | string sub -s 4 \
    | string replace -r '^.* -> ' ''
end
