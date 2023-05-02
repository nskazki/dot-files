function path-cli -a input
  if blank $input
    set input .
  end

  clip-set (path resolve $input)
end
