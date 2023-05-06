function __git_distance__
  if [ (count $argv) -eq 1 ]
    if __git_is_range__ $argv[1]
      set range $argv[1]
    else
      set range $argv[1]..HEAD
    end
  else if [ (count $argv) -eq 2 ]
    set range $argv[1]..$argv[2]
  else
    return 1
  end

  git rev-list --count $range
end
