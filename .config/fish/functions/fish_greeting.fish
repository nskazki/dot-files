function fish_greeting
  # https://seethingswarm.itch.io/catset
  # https://github.com/maandree/util-say
  #
  # find ~/Documents/catset_gifs \( -name '*attack*' -or -name '*hurt*' -or -name '*die*' -or -name '*ledge*' -or -name '*land*' -or -name '*fall*' -or -name '*dash*' -or -name '*wall*' -or -name '*jump*' -or -name '*crouch*' -or -name '*fright*' -or -name '*idle_8*'  \) -print -delete
  # find ~/Documents/catset_gifs \( -name '*[12][0-9].png' -or -name '*8.png' -or -name '*9.png' \) -print -delete
  # shopt -s globstar
  # for file in ~/Documents/catset_gifs/**/*.png; do
  #   ponytool --import image --magnified 1 --file $file --balloon n --export ponysay --balloon n --file - --chrome 1 --platform xterm > $file.pony
  # done

  if test -d ~/Documents/catset_gifs
    cat (random choice (find ~/Documents/catset_gifs -name '*.pony'))
  end
end
