function ys
  yarn && TRUST_NETWORK=true WEBPACK_SOURCE_MAP=false WEBPACK_DIRTY_LINTERS=false yarn start $argv
end
