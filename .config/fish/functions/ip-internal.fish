function ip-internal
  if ! [ -f (yarn --offline global bin)/internal-ip ]
    yarn global --no-progress --non-interactive add internal-ip-cli &>/dev/null
  end

  if [ "$status" -ne 0 ]
    color red 'cannot install the internal-ip-cli package'
    return 1
  end

  internal-ip --ipv4 $argv 2>/dev/null || echo '127.0.0.1'
end
