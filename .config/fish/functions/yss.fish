function yss
  rm -rf node_modules/.cache public/webpack/ && yarn && TRUST_NETWORK=true WEBPACK_SOURCE_MAP=false WEBPACK_DIRTY_LINTERS=false yarn start $argv
end
