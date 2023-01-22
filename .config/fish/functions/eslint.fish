function eslint
  if test -e yarn.lock
    yarn exec --silent -- eslint (strip-line-number $argv)
  else
    npm exec -- eslint $argv (strip-line-number $argv)
  end
end
