if has('unix')
	runtime debian.vim
	let g:vimpath=$HOME.'/.vim'
endif

if has('win32')
	let g:vimpath=$HOME.'/vimfiles'
endif

" Plugin Options
if PluginEnabled('vim-airline')
	if has('gui_running') || &t_Co==256
		let g:airline_theme='bubblegum'
	else
		let g:airline_theme='monochrome'
	endif
	let g:airline#extensions#tabline#enabled=1
	" let g:airline_powerline_fonts=1
	if !exists('g:airline_symbols')
		let g:airline_symbols={}
	endif
	let g:airline_symbols.colnr = ' ㏇:'
	let g:airline_symbols.maxlinenr=''
	let g:airline_section_y='' " turn off file encoding, file format
endif

" Searching
set incsearch hlsearch
nnoremap <silent><Space> :noh<CR>
vnoremap <silent><Space> <Esc>:noh<CR>gv

" Font, Colorscheme
set cursorline
highlight CursorLine cterm=NONE ctermbg=236 " 236=Gray19
highlight CursorLineNr cterm=NONE ctermbg=236 " 236=Gray19
highlight LineNr ctermbg=238 " 238=Gray27
if has('unix')
	set guifont=Lucida\ Console\ 11
endif
if has('win32')
	set guifont=Lucida_Console:h11
endif

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

set backspace=indent,eol,start
set display=lastline,uhex
set whichwrap+=<,>,[,]
set wildmenu wildmode=list,full
let mapleader="\\"
set notimeout ttimeout ttimeoutlen=0
set splitbelow splitright
set diffopt+=vertical
set history=100
set directory=~/tmp//,~/tmp,/var/tmp,.,/tmp

" Spell
set spelllang=en_us
exec 'set spellfile='.g:vimpath.'/spell/en.utf-8.add'

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
