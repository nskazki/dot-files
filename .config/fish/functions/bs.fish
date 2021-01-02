function bs
  rm -rf public/assets && bundle install && bundle exec rake dashboard:stylesheets && TRUST_NETWORK=true bundle exec rails $argv s
end
