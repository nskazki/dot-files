function any-ruby
  for arg in (strip-line-number $argv)
    if path filter -f -q -- $arg && string match -q -- .rb (path extension $arg)
      return 0
    else if path filter -d -q -- $arg && fd -q -e .rb . -- $arg
      return 0
    end
  end

  return 1
end
