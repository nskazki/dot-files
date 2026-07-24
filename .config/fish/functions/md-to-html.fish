function md-to-html -a input
  set output (path change-extension html -- $input)
  echo $output
  wget -nc -O /tmp/md-to-html-water.css https://cdn.jsdelivr.net/npm/water.css@2/out/water.css
  npx -y showdown makehtml -p github -c completeHTMLDocument yes -i $input -o $output
  npx -y juice --css /tmp/md-to-html-water.css $output $output
end
