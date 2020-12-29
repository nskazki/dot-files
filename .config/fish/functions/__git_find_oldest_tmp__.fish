function __git_find_oldest_tmp__
  set logs (git log --format='%h %s' -n100)

  for log in $logs
    if string match -qr '^[[:alnum:]]+ [[:digit:]]+$' -- $log
      set oldest $log
    else
      string match -r '^[[:alnum:]]+' -- $oldest
      break
    end
  end
end
