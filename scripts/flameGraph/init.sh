#!/bin/bash
set -e

long="$1"
pname="$2"

if [[ "$long" == "--help" || "$long" == "-h" ]]; then
  echo "node-perf-record [time] [proc-grep-str]"
  exit 0
elif [[ -z "$long" ]]; then
   long="30"
   pname="node --perf-basic-prof"
elif [[ -z "$pname" ]]; then
   pname="node --perf-basic-prof"
fi

echo "long: $long"
echo "grep: $pname"

oldDir="$PWD"
ownDir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
tmpDir="$ownDir/tmp"
outDir="$ownDir/out"

mkdir -p "$outDir" "$tmpDir"

pid="$("$ownDir/getprocess.js" "$pname")"
echo "pid: $pid"

currDate="$(date '+%d.%m.%y-%H:%M')"
tmpfile="$tmpDir/$currDate-nodestacks.tmp"
outfile="$outDir/$currDate-nodestacks-$(echo "$pname" | sed -e 's/ //g')-$long.svg"
echo "tmp: $tmpfile"
echo "out: $outfile"

cd "$tmpDir"

perf record -F 99 -p "$pid" -g -- sleep "$long"
perf script > "$tmpfile"

cd "$ownDir/FlameGraph"
./stackcollapse-perf.pl < "$tmpfile" | ./flamegraph.pl --color=js > "$outfile"

cd "$oldDir"

chown nskazki:nskazki -R "$tmpDir"
chown nskazki:nskazki -R "$outDir"

echo "$outfile" | xclip -selection c
