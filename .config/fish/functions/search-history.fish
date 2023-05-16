# https://github.com/PatrickF1/fzf.fish/blob/main/functions/_fzf_search_history.fish

function search-history
  if test -z "$fish_private_mode"
    builtin history merge
  end

  set commands (
    builtin history --null |
    fzf --exact --read0 --print0 --multi --tiebreak=index --query=(commandline) |
    string split0
  )

  if present $commands
    commandline --replace -- $commands
  end

  commandline --function repaint
end
