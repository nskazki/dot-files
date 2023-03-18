function rspec
  if ! set -q LOG_LEVEL
    set -x LOG_LEVEL warn
  end

  bundle exec rspec $argv
end
