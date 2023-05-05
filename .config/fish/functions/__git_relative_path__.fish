function __git_relative_path__
  isatty || read -az argv
  realpath --relative-to=$PWD (string replace -r -- '^' (git root)/ $argv)
end
