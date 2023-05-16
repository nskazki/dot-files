function __t_args__ -a lang
  if string match -q -- $lang rb
    set ruby
    set pattern '_spec\.rb$'
    set specdir "$(git root)/spec"
  else
    set pattern '(\.[^/]+)*\.spec\.js$'
    set specdir "$(git root)/app/vue-dashboard/spec/"
  end

  set results

  for arg in $argv[2..]
    set clean_arg (strip-line-number $arg)
    set clean_ext (path extension $clean_arg)

    if ! path filter -f -q -- $clean_arg
      color brblack "targs: couldn't find $arg" >&2
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
        set result (relative $arg)
      else
        set result (relative $clean_arg)
      end

      if ! contains $result $results
        set -a results $result
        echo $result
      end
    else
      for result in (relative (__t_args_lookup__ $pattern $clean_arg $arg))
        if ! contains $result $results
          set -a results $result
          echo $result
        end
      end
    end
  end
end

function __t_args_lookup__ -a pattern clean_arg arg
  set -e parts
  set -p parts (path change-extension -- '' (path basename -- $clean_arg))
  set source (path dirname (path resolve $clean_arg))

  # prefixing with the directory right away to avoid matching index.js files
  set -p parts (path basename $source)
  set source (path dirname $source)

  while true
    set base (string join -- / $parts)
    set query "$base$pattern"
    set results (fd -p -s -t f -- $query $specdir)

    if blank $results
      break
    end

    if present $results && string-match-all (path dirname $results)
      for result in $results
        echo $result
      end

      break
    else if present $source && ! string match -q -- / $source
      set -p parts (path basename $source)
      set source (path dirname $source)
    else
      color brblack "targs: couldn't find an exact match for $arg" >&2
      break
    end
  end
end

