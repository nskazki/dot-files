function diff-strings -a first second
  # https://stackoverflow.com/a/45854020/16062729
  git -c color.diff=always diff (echo $first | git hash-object -w --stdin) (echo $second | git hash-object -w --stdin)
end
