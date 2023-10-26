function package-upgrade
  if present $argv
    set cmd $argv
  else
    set cmd '.'
  end

  if test -e yarn.lock
    set yarn
  end

  set outdated (FORCE_COLOR=3 node /Volumes/Repos/outdated | string collect)

  if string match -qr '\\berror ' -- (uncolor $outdated)
    echo -- $outdated
    return 1
  end

  if blank $outdated
    color yellow 'everything is up to date it seems'
    return 1
  end

  set lines (echo $outdated | fzf --multi)

  if blank $lines
    color yellow 'nothing is selected'
    return 1
  end

  for line in $lines
    set match (string match -r '^(.+?)\\s+.+?\\s+(.+?)\\s+' -- $line)
    set name $match[2]
    set latest $match[3]

    if blank $name || blank $latest
      color red 'something is off about the' $line
      return 1
    end

    set current (jq ".dependencies.\"$name\",.devDependencies.\"$name\"" $cmd/package.json | string match -v null | string unescape)
    if ! string match -qr '^([~^])?\\d+\.\\d+\.\\d+$' -- $current
      color red 'better upgrade it manually from' $name@$current 'to' $latest
      return 1
    end

    set prefix (string match -r '^[~^]' -- $current)
    set -a packages "$name@$prefix$latest"
  end

  if set -q yarn
    echo 'yarn --cwd' \"$cmd\" 'add --' $packages
    yarn --cwd "$cmd" add -- $packages
  else
    echo 'npm --prefix' \"$cmd\" 'add --' $packages
    npm --prefix "$cmd" add -- $packages
  end
end
