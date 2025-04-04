function sync-hooks
  if present $argv
    set cwd (realpath $argv)
  else
    set cwd (realpath .)
  end

  set hooks 'commit-msg'\
            'post-commit'\
            'post-checkout'\
            'prepare-commit-msg'

  for hook in $hooks
    set -a paths ~/.scripts/$hook
  end

  echo 'cwd is' $cwd
  echo 'paths are' $paths

  mkdir $cwd/.git/hooks/

  for path in $paths
    cp $path $cwd/.git/hooks/
  end
end
