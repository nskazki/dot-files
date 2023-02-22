function __git_find_latest_tmp__
  set last (git show -s --format='%h %s' HEAD)

  if string match -qr '^[[:alnum:]]+ [[:digit:]]+$' -- $last
    string match -r '^[[:alnum:]]+' -- $last
  end
end
