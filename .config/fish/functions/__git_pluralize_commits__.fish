function __git_pluralize_commits__ -a count
  if string match -q -- $count 1
    echo "$count commit"
  else
    echo "$count commits"
  end
end
