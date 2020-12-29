function __git_find_latest_tmp__
  set log (git log --format='%h %s' -n1)

  if string match -qr '^[[:alnum:]]+ [[:digit:]]+$' -- $log
    string match -r '^[[:alnum:]]+' -- $log
  end
end
