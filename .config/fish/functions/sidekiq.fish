function sidekiq
  if ! set -q LOG_LEVEL
    set -x LOG_LEVEL debug
  end

  bundle exec sidekiq $argv
end
