function llama
  command llama $argv 2> /tmp/llama && cd (cat /tmp/llama)
end
