function tp
  for arg in $argv
    set clean_arg (strip-line-number $arg)
    if path filter -f -q -- $clean_arg && ! string match -q -r -- 'spec\.(js|rb)$' $clean_arg
      set -e parts
      set -p parts (path change-extension -- '' (path basename -- $clean_arg))
      set source (path dirname (path resolve $clean_arg))

      while true
        set base (string join -- / $parts)
        set query "$base(\.[^/]+)*[_.]spec\.(js|rb)\$"
        set results (fd -p -s -t f -- $query)

        if present $results && string-match-all (path dirname $results)
          for result in $results
            echo $result
          end

          break
        else if present $source && ! string match -q -- / $source
          set -p parts (path basename $source)
          set source (path dirname $source)
        else
          echo $clean_arg
          break
        end
      end
    else if path filter -f -q -- $clean_arg && string match -q -- .js (path extension $clean_arg)
      echo $clean_arg
    else
      echo $arg
    end
  end
end
