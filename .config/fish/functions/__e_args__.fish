function __e_args__ -a lang
  if string match -q -- $lang rb
    set ruby
  end

  for arg in $argv[2..]
    set clean_arg (strip-line-number $arg)
    set clean_ext (path extension $clean_arg)

    if ! path filter -f -q -- $clean_arg
      color brblack "eargs: couldn't find $arg" >&2
      continue
    end

    if set -q ruby
      if ! string match -q -- '.rb' $clean_ext || string match -q -r -- '/db/' $clean_arg
        continue
      end
    end

    if ! set -q ruby && ! string match -q -r -- '.js|.vue' $clean_ext
      continue
    end

    echo $clean_arg
  end
end
