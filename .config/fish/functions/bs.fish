function bs
  rbenv shell 2.7.7
  mailcatcher
  rbenv shell --unset

  rm -rf public/assets && bundle install && bundle exec rake dashboard:stylesheets && TRUST_NETWORK=true bundle exec rails $argv s --config /Volumes/Repos/GleamSmtp/config.ru
end
