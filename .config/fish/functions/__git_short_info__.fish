function __git_short_info__
  git log -n1 --color=always --pretty='%C(cyan)%h%C(reset) (%s)' $argv
end
