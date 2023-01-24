function bundle
  if string match -q exec -- $argv[1] && string match -q rake -- $argv[2]
    rake $argv[3..-1]
  else
    command bundle $argv
  end
end

