function __git_gt_commit__
  if [ (count $argv) -ne 2 ]
    return 0
  end

  set distance_a (git rev-list --count $argv[1]..HEAD)
  set distance_b (git rev-list --count $argv[2]..HEAD)

  test $distance_a -gt $distance_b
end
