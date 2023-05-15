function __t_args__ -a lang
  if string match -q -- $lang rb
    set ruby
    set pattern '_spec\.rb$'
    set specdir "$(git root)/spec"
  else
    set pattern '(\.[^/]+)*\.spec\.js$'
    set specdir "$(git root)/app/vue-dashboard/spec/"
  end

  for arg in $argv[2..]
    set clean_arg (strip-line-number $arg)
    set clean_ext (path extension $clean_arg)

    if ! path filter -f -q -- $clean_arg
      color brblack "debug: couldn't find $arg" >&2
      continue
    end

    if set -q ruby && ! string match -q -- '.rb' $clean_ext
      continue
    end

    if ! set -q ruby && ! string match -q -r -- '.js|.vue' $clean_ext
      continue
    end

    if string match -q -r -- $pattern $clean_arg
      if set -q ruby
        echo $arg
      else
        echo $clean_arg
      end
    else
      set -e parts
      set -p parts (path change-extension -- '' (path basename -- $clean_arg))
      set -p parts (path basename $source) # prefixing with the directory right away to avoid matching index.js files
      set source (path dirname (path dirname (path resolve $clean_arg)))

      while true
        set base (string join -- / $parts)
        set query "$base$pattern"
        set results (fd -p -s -t f -- $query $specdir)

        if present $results && string-match-all (path dirname $results)
          for result in $results
            echo $result
          end

          break
        else if present $source && ! string match -q -- / $source
          set -p parts (path basename $source)
          set source (path dirname $source)
        else
          color brblack "debug: couldn't find a match for $arg" >&2
          break
        end
      end
    end
  end
end
