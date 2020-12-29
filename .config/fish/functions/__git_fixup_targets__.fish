function __git_fixup_targets__
  # https://stackoverflow.com/a/29613573
  git log --format='%s' -n100 \
    | string match -er '^fixup! ' \
    | string replace -r '^(fixup! )+' '' \
    | uniq \
    | string replace -ar '[^^]' '[$0]' \
    | string replace -a '^' '\^'
end
