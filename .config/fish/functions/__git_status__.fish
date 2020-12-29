function __git_status__
  echo
  git -c color.status=always status | string collect
  echo
end
