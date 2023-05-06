function __git_inline_info__
  git log -n1 --pretty='%C(cyan)%h%C(reset) (%s)' $argv
end
