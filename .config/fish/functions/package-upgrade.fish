function package-upgrade
  if present $argv
    set cmd $argv
  else
    set cmd '.'
  end

  if test -e yarn.lock
    set yarn 1
  else
    set yarn 0
  end

  if test $yarn -eq 1
    set outdated (yarn --cwd "$cmd" outdated --color 2>&1 | string collect)
  else
    set outdated (npm --prefix "$cmd" --color=always outdated 2>&1 | string collect)
  end

  if string match -qr '\\berror ' -- (uncolor $outdated)
    echo -- $outdated
    return 1
  end

  if blank $outdated
    color yellow 'everything is up to date it seems'
    return 1
  end

  if test $yarn -eq 1
    set lines (echo $outdated | tail -n +7 | head -n -1 | fzf --multi)
  else
    set lines (echo $outdated | tail -n +1 | fzf --multi)
  end

  if blank $lines
    color yellow 'nothing is selected'
    return 1
  end

  for line in $lines
    set match (string match -r '^(.+?)\\s+.+?\\s+.+?\\s+(.+?)\\s+' -- $line)
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

  if test $yarn -eq 1
    echo 'yarn --cwd' \"$cmd\" 'add --' $packages
    yarn --cwd "$cmd" add -- $packages
  else
    echo 'npm --prefix' \"$cmd\" 'add --' $packages
    npm --prefix "$cmd" add -- $packages
  end
end
