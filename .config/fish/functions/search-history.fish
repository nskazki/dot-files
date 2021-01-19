# https://github.com/PatrickF1/fzf.fish/blob/main/functions/__fzf_search_history.fish

function search-history
  set line (
    builtin history --null --show-time="%y/%m/%d %H:%M:%S | " |
    fzf --read0 --tiebreak=index --query=(commandline) |
    string collect
  )

  if present $line
    set cmd (string split --max 1 " | " $line)[2]
    commandline --replace -- $cmd
  end

  commandline --function repaint
end
