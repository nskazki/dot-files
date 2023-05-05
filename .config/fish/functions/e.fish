function e
  if blank $argv
    color brblack "yarn eslint" >&2
    yarn eslint
  else if any-ruby $argv
    color brblack "rubocop $argv" >&2
    rubocop $argv
  else
    color brblack "eslint $argv" >&2
    eslint $argv
  end
end
