function __git_status__
  echo
  echo "$(git -c color.status=always status)" # removes the optional new line at the end
  echo
end
