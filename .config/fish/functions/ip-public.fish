function ip-public
  if ! [ -f (yarn --offline global bin)/public-ip ]
    yarn global --no-progress --non-interactive add public-ip-cli &>/dev/null
  end

  if [ "$status" -ne 0 ]
    color red 'cannot install the public-ip-cli package'
    return 1
  end

  public-ip --ipv4 $argv 2>/dev/null || ip-internal $argv
end
