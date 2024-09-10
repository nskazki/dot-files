function bs
  if ! pgrep -q -f (rbenv which mailcatcher)
    rbenv exec mailcatcher
  end

  rm -rf public/assets && bundle install && rake dashboard:stylesheets && TRUST_NETWORK=true rails $argv s --config /Volumes/Repos/GleamSmtp/config.ru
end
