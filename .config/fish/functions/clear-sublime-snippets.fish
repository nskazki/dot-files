function clear-sublime-snippets
  for snippet in (find "$HOME/Library/Application Support/Sublime Text 3/Packages/" -name "*.sublime-snippet")
    echo > $snippet
  end
end
