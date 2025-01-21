function oxford-comma
  if test (count $argv) -eq 0
    return 1
  else if test (count $argv) -eq 1
    echo -- $argv
  else if test (count $argv) -eq 2
    echo -- $argv[1] and $argv[2]
  else
    echo -- (string join ', ' -- $argv[1..-2]), and $argv[-1]
  end
end
