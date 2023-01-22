function uncolor
  string replace -ra '\e\[[^m]*m' '' -- $argv
end
