function ys
  rm -rf node_modules/.cache public/webpack/ && yarn && TRUST_NETWORK=true yarn start $argv
end
