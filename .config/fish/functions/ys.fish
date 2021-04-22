function ys
  rm -rf node_modules/.cache public/webpack/ && yarn && TRUST_NETWORK=true WEBPACK_DIRTY_LINTERS=false yarn start $argv
end
