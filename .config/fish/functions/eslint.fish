function eslint
  if test -e yarn.lock
    yarn exec eslint $argv
  else
    npm exec eslint $argv
  end
end
