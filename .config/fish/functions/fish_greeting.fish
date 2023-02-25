function fish_greeting
  # https://seethingswarm.itch.io/catset
  # find ~/Documents/catset_gifs \( -name '*hurt*' -or -name '*dei*' -or -name '*ledge*' -or -name '*land*' -or -name '*fall*' -or -name '*dash*' -or -name '*wall*' -or -name '*jump*' -or -name '*crouch*' -or -name '*fright*' -or -name '*idle_8*'  \) -print -delete
  # for file in (find ~/Documents/catset_gifs -name '*.gif'); convert $file -filter point -resize 1000% $file; end
  # for file in (find ~/Documents/catset_gifs -name '*.gif'); convert $file $file.png; end
  # find ~/Documents/catset_gifs \( -name '*[12][0-9].png' -or -name '*8.png' -or -name '*9.png' \) -print -delete

  # TODO: try again after the v3.5 release
  if false && test -d ~/Documents/catset_gifs && test $PWD = $HOME
    imgcat (random choice (find ~/Documents/catset_gifs -name '*.png'))
  end
end
