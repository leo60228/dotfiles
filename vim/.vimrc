let c='a'
while c <= 'z'
  exec "set <A-".c.">=\e".c
  exec "imap \e".c." <A-".c.">"
  let c = nr2char(1+char2nr(c))
endw

set ttimeout ttimeoutlen=50
set backspace=2
set ai

set tabstop=8 softtabstop=0 expandtab shiftwidth=2 smarttab
