function bs
  if ! pgrep -q -f (RBENV_VERSION=2.7.7 rbenv which mailcatcher)
    RBENV_VERSION=2.7.7 rbenv exec mailcatcher
  end

  rm -rf public/assets && bundle install && rake dashboard:stylesheets && TRUST_NETWORK=true rails $argv s --config /Volumes/Repos/GleamSmtp/config.ru
end
