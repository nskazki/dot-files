function t
  set paths (tp $argv)

  if blank $paths
    color brblack "yarn t-vue-dashboard" >&2
    yarn t-vue-dashboard
  else if any-ruby $paths
    color brblack "rspec $paths" >&2
    rspec $paths
  else
    color brblack "yarn t-vue-dashboard-path $paths" >&2
    yarn t-vue-dashboard-path $paths
  end
end
