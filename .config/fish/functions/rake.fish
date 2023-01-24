function rake
  set Gleam (upward Gleam)

  if present $Gleam
    command bundle exec rake -E "require '$Gleam/config/environment.rb'; Rails.logger = Logger.new(STDOUT); Rails.logger.level = ENV.fetch('LOG_LEVEL', 'DEBUG')" $argv
  else
    command bundle exec rake $argv
  end
end
