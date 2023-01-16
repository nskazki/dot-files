#! /usr/bin/env bash

maxlength() {
  max='0'
  for arg in "$@"; do
    len="${#arg}"
    if [ "$len" -gt "$max" ]; then
      max="$len"
    fi
  done
  echo "$max"
}

padright() {
  max="$1"
  chr="$2"
  for arg in ${@:3:$#}; do
    while [ "${#arg}" -lt "$max" ]; do
      arg+="$chr"
    done
    echo "$arg"
  done
}

padleft() {
  max="$1"
  chr="$2"
  for arg in ${@:3:$#}; do
    while [ "${#arg}" -lt "$max" ]; do
      arg="$chr$arg"
    done
    echo "$arg"
  done
}

if [[ -n "$@" ]]; then
  input="$(cat -- "$@")"
else
  input="$(cat -)"
fi

# http://wordlist.aspell.net/dicts/

words="$(echo "$input" | sed -E "s/[^a-zA-Z']/ /g; s/([a-z])([A-Z])/\1 \2/g; s/([A-Z]+)([A-Z][a-z]+)/\1 \2/g; s/(^| )[A-Z]+( |\$)/ /g")"
readarray -t mistakes <<< "$(echo "$words" | hunspell -d en_US -l -p ~/.hunspell/complete | sort -u)"

if [[ -n "${mistakes[@]}" ]]; then
  echo -e "\e[0;31mPossible mistakes:\e[0m\n"

  max_index="$(maxlength "${#mistakes[@]}")"
  max_mistake="$(maxlength "${mistakes[@]}")"

  for index in "${!mistakes[@]}"; do
    mistake="${mistakes[index]}"
    correct="$(echo "$mistake" | hunspell -d en_US -p ~/.hunspell/complete | grep "&" | head -n 1 | sed -r 's/^.*: //; s/,//g')"

    if [ -n "$correct" ]; then
      suffix="→ $correct"
    else
      suffix="✗"
    fi

    printf "  %s. %s %s\n" "$(padleft $max_index " " "$index")" "$(padright "$max_mistake" " " "${mistakes[index]}")" "$suffix"
  done
fi
