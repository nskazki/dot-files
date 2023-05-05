function td
  set paths (tp $argv)

  if blank $paths
    color brblack "yarn t-vue-dashboard"
    yarn t-vue-dashboard
  else if any-ruby $paths
    color brblack "rspec $paths"
    rspec $paths
  else
    color brblack "yarn t-vue-dashboard-debug $paths"
    yarn t-vue-dashboard-debug $paths
  end
end
