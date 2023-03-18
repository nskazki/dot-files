function rails
  if ! set -q LOG_LEVEL
    set -x LOG_LEVEL debug
  end

  bundle exec rails $argv
end
