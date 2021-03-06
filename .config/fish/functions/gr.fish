function gr
  if ! __in_git_repo__
    return
  end

  git log --walk-reflogs --color=always --format='%C(yellow)%gd%C(reset) %C(magenta)%h%C(auto)%d %gs' \
    | fzf \
    | string split --max 2 ' ' | head -n2 | tail -n1
end
