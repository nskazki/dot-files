function bs
  if ! tmux has-session -t my_mailtutan
    tmux new-session -d -s my_mailtutan mailtutan
  end

  rm -rf public/assets && bundle install && rake dashboard:stylesheets && COFFEESCRIPT_SOURCE_PATH=scratch/scripts/coffee-script.js RUBYOPT="-r/Volumes/Repos/GleamScratch/disable_ssl.rb" rails $argv s
end
