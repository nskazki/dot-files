#! /usr/bin/env bash

# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -Eeuo pipefail
trap "notify-send -u critical -i error 'Backup FAILED'" ERR

backup_repos="$HOME/.backup_repos"
backup_archives="$HOME/.backup_archives"

rm -rf "$backup_repos"
rm -rf "$backup_archives"

mkdir -p "$backup_repos"
mkdir -p "$backup_archives"

readarray -t git_folders <<< "$(find ~/ruby/ ~/node.js/ -name '.git' -type d)"

for git_folder in "${git_folders[@]}"; do
  repo="${git_folder/\/\.git/}"
  check="$(git -C "$repo" rev-parse --show-toplevel 2>/dev/null)"
  if [[ "$check" = "$repo" ]]; then
    name="${repo/$HOME\//}"
    backup_repo="$backup_repos/$name"
    backup_archive="$backup_archives/$name.tar"

    if [[ -n "$name" && ! "$name" =~ ^/ ]]; then
      mkdir -p "$backup_repo"
      mkdir -p "$(dirname "$backup_archive")"
      git clone -q --bare "$repo" "$backup_repo"
      tar -cf "$backup_archive" -C "$(dirname "$backup_repo")" "$(basename "$backup_repo")"
      echo "✔️  $repo"
    else
      echo "💀 $repo"
    fi
  else
    echo "❌ $repo"
  fi
done

rclone -v sync "$backup_archives" google-drive:repos
notify-send -t 10000 -u low -i media-floppy 'Backup OK'
