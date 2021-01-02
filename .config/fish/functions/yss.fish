function yss
  rm -rf node_modules/.cache public/webpack/ && yarn && TRUST_NETWORK=true WEBPACK_SOURCE_MAP=false yarn start $argv
end
