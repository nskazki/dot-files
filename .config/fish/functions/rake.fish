function rake
  if ! set -q LOG_LEVEL
    set -x LOG_LEVEL info
  end

  bundle exec rake $argv
end
