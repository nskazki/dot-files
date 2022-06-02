function jest
  set file_and_line_pattern '^(?<matched_file>.+):(?<matched_line>\d+)$'

  for arg in $argv
    echo $arg
    if string match -q -r $file_and_line_pattern -- $arg && test -f $matched_file
      set -a file $matched_file
      set -a line $matched_line
    else
      set -a other $arg
    end
  end

  if test (count $file) -ne 1
    run_jest $argv
    return
  else
    run_jest $argv
    return
  end

  # https://jestjs.io/docs/cli

  set opening_pattern = '^(?<matched_spaces>\s*)(?:f|x)?(?:it|test|describe)(?:.skip|only|todo|failing)*\([\'`"](?<matched_description>.+)[\'`"], (' # .each and multiline descriptions aren't supported
  set closing_pattern = '^(?<matched_spaces>\s*)}\)'

  for line in (cat $file)
    echo $line
    if string match -q -r $opening_pattern -- $line
      echo opening
    else if string match -q -r $closing_pattern -- $line
      echo closing
    end
  end
end

function run_jest
  echo $argv
  return

  if test -e yarn.lock
    yarn exec --silent -- jest $argv
  else
    npm exec -- jest $argv
  end
end
