function gr
  if ! __in_git_repo__
    return 1
  end

  git log --walk-reflogs --color=always --format='%C(yellow)%gd%C(reset) %C(magenta)%h%C(auto)%d %gs' \
    | fzf --exact \
    | string split --max 2 ' ' | head -n2 | tail -n1
end
