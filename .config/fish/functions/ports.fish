function ports
  sudo lsof -i -n -P $argv | columns -c1 -c2 -c3 -c5 -c8 -c9 -fLISTEN
end
