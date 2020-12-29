function __git_find_every_tmp__
  set logs (git log --format='%h %s' -n100)

  for log in $logs
    if string match -qr '^[[:alnum:]]+ [[:digit:]]+$' -- $log
      string match -r '^[[:alnum:]]+' -- $log
    end
  end
end
