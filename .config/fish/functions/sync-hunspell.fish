# more dictionaries:
#
#  @cspell/dict-css/css.txt.gz
#  @cspell/dict-npm/npm.txt.gz
#  @cspell/dict-node/node.txt.gz
#  @cspell/dict-html/html.txt.gz
#  @cspell/dict-fonts/fonts.txt.gz
#  @cspell/dict-filetypes/filetypes.txt.gz
#  @cspell/dict-companies/companies.txt.gz
#  @cspell/dict-typescript/typescript.txt.gz
#  @cspell/dict-html-symbol-entities/entities.txt.gz

function sync-hunspell
  if ! [ -f (yarn --offline global bin)/cspell ]
    yarn global --no-progress --non-interactive add cspell &>/dev/null
  end

  set node_modules (yarn global dir)/node_modules
  set dictionaries\
    $node_modules/@cspell/dict-fullstack/fullstack.txt.gz\
    $node_modules/@cspell/dict-software-terms/softwareTerms.txt.gz

  set custom ~/.hunspell/custom
  set complete ~/.hunspell/complete

  if [ -f $custom ]
    set -a dictionaries $custom
  end

  for dictionary in $dictionaries
    if string match -rq '\\.gz$' $dictionary
      set dynamic_cat 'gzcat'
    else
      set dynamic_cat 'cat'
    end

    set -a buffer (eval $dynamic_cat -- $dictionary | string replace -ar '#.*' '' | string split -n ' ' | string trim | string match -r '^.+$')
  end

  mkdir -- (dirname -- $complete)
  string collect $buffer | sort -u > $complete
  echo 'buffer' (count $buffer)
  echo 'total ' (cat $complete | wl)
end
