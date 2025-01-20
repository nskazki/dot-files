function package-upgrade
  set package (upward package.json)
  set package_lock (upward package-lock.json)

  if blank $package
    color red 'could not find the package.json'
    return 1
  end

  if blank $package_lock
    color red 'could not find the package-lock.json'
    return 1
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
    set match (string match -r '^(.+?)\\s+.+?\\s+(.+?)\\s*$' -- $line)
    set name $match[2]
    set latest $match[3]

    if blank $name || blank $latest
      color red 'could not extract the name or the version from' $line
      return 1
    end

    set current (__read_field__ $package dependencies $name || __read_field__ $package devDependencies $name)
    set range (string match -r '^[~^]' -- $current)
    set latest_ranged "$range$latest"
    set -a names $name

    if blank $current
      color red 'could not find the current version of' $name
      return 1
    end

    if ! string match -qr '^([~^])?\\d+\.\\d+\.\\d+$' -- $current
      color red 'would not override the non-standard version' $current
      return 1
    end

    if __has_field__ $package overrides $name
      color blue 'updating' $name 'override to' $latest_ranged
      __write_field__ $package overrides $name $latest_ranged || return $status
    end

    if __has_field__ $package dependencies $name
      color blue 'updating' $name 'dependency to' $latest_ranged
      __write_field__ $package dependencies $name $latest_ranged || return $status
    end

    if __has_field__ $package devDependencies $name
      color blue 'updating' $name 'dev dependency to' $latest_ranged
      __write_field__ $package devDependencies $name $latest_ranged || return $status
    end
  end

  npm install || return $status
  git add -- $package $package_lock || return $status
  git commit -m "Upgrade $(oxford-comma $names)"
end
