function bs
  if ! tmux has-session -t my_mailtutan
    tmux new-session -d -s my_mailtutan mailtutan
  end

  rm -rf public/assets && bundle install && rake dashboard:stylesheets && rails $argv s --config /Volumes/Repos/GleamSmtp/config.ru
end
