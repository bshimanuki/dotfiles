" Settings
let &showbreak='....'
set breakindent
set breakindentopt=shift:0
set backupcopy=yes
set fileformats=unix,dos
set nofixendofline
set number

set showcmd cmdheight=2
set tabstop=2 shiftwidth=2
set nojoinspaces

" Remaps
"" Save and Quit
command! -bang Q q<bang>
command! -bang Qa qa<bang>
command! -bang QA qa<bang>
command! W w
command! Wq wq
command! WQ wq
"" Movement
noremap <Up> gk
noremap <Down> gj
noremap <Home> g<Home>
noremap <End> g<End>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap gb :bn<CR>
nnoremap gB :bp<CR>
