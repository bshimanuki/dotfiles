setlocal spell
setlocal iskeyword-=_
command! Wordcount w !detex |wc -w
