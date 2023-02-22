function __git_next_tmp_message__
  set last (git show -s --format='%s' $argv | string replace -r '^(fixup! )+' '' | string match -r '^[[:digit:]]+$')

  if present $last
    echo (math 1 + $last)
  else
    echo 1
  end
end
