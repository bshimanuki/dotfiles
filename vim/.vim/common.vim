" Settings common between vim and neovim
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

if PluginEnabled('CamelCaseMotion')
	call camelcasemotion#CreateMotionMappings(',')
endif


let s:exe_ext = 'exe|so|dll'
let s:compiled_ext = 'd|o|pdf|py[cdo]'
let s:img_ext = 'gif|jpg|png'
let s:data_ext = 'npy|npz|onnx|pb|pkl|pt'
let s:tex_ext = 'aux|bbl|bcf|blg|brf|fdb_latexmk|fls|idx|ilg|lof|lol|lot|pre|synctex\.gz|synctex\.gz\(busy\)|toc|x\.gnuplot' " exclude: log
let s:file_ext = join([s:exe_ext, s:compiled_ext, s:img_ext, s:data_ext, s:tex_ext], '|')
let s:dir_ext = 'git|hg|svn'
if PluginEnabled('ctrlp.vim') && !PluginEnabled('fzf.vim')
	let g:ctrlp_working_path_mode='a'
	let g:ctrlp_custom_ignore = {
				\ 'dir':  '\v[\/]\.(' . s:dir_ext . ')$',
				\ 'file': '\v\.(' . s:file_ext . ')$',
				\ }
	let g:ctrlp_user_command = ['.git/', 'cd %s && git ls-files . -oc --exclude-standard | grep -v -E "\.(' . s:file_ext . ')$"']
endif

if PluginEnabled('vim-easymotion')
	noremap <Plug>(easymotion-prefix) <Nop>
endif

if PluginEnabled('fzf.vim')
	let s:fzf_dir = '"${dir:-' . getcwd() . '}"'
	let s:fzf_dir_ext = substitute(s:dir_ext, '|', ' -o -path \\*/.', 'g')
	let s:fzf_find_cmd = '(find -L ' . s:fzf_dir . ' \( -path \*/.' . s:fzf_dir_ext .  ' \) -prune -o -type f | sed "s|^' . s:fzf_dir . '/||")'
	let s:fzf_git_gitignore_cmd = 'git check-ignore -q ' . s:fzf_dir . ' 2> /dev/null'
	let s:fzf_git_lsfiles_cmd = 'git ls-files ' . s:fzf_dir . ' -oc --exclude-standard 2> /dev/null'
	let s:fzf_grep_cmd = '(grep -v -E "\.(' . s:file_ext . ')$" || [[ $? == 1 ]])'
	let s:fzf_cmd = '(' . s:fzf_git_gitignore_cmd . ' ; [ $? -eq 1 ] && ' . s:fzf_git_lsfiles_cmd . ' || ' . s:fzf_find_cmd . ') | ' . s:fzf_grep_cmd
	function! Fzfvimfiles()
		if has('gui')
			call fzf#vim#files(getcwd(), {'source': s:fzf_cmd, 'sink': 'drop'})
		else
			call fzf#vim#files(getcwd(), {'source': s:fzf_cmd})
		endif
		if !has('nvim')
			" NB: fzf puts vim into insert after opening a file otherwise but
			" stopinsert puts vim into normal mode while selecting a file
			stopinsert
		endif
	endfunction
	command Fzfvimfiles :silent! call Fzfvimfiles()
	nnoremap <silent><C-p> :Fzfvimfiles<CR>
	nnoremap <silent><C-f> :silent Buffers<CR>
	nnoremap <silent>g[ :silent Lines<CR>
	nnoremap <silent>g/ :silent BLines<CR>
	nnoremap <silent>g9 :silent Rg<CR>
	nnoremap <silent>g0 :silent Changes<CR>
endif

if PluginEnabled('vim-fugitive')
	nnoremap <silent><leader>g :silent Ggrep! -w <cword><CR>:copen<CR>:redraw!<CR>
	nnoremap <silent><leader>bb :exec line('.') . 'GBrowse!'<CR>
	vnoremap <silent><leader>bb :GBrowse!<CR>
	nnoremap <silent><leader>bf :GBrowse!<CR>
	vnoremap <silent><leader>bf <Esc>:GBrowse!<CR>gv
	nnoremap <silent><leader>bo :exec line('.') . 'GBrowse'<CR>
	vnoremap <silent><leader>bo :GBrowse<CR>
	nnoremap gb :silent Git blame -C<CR>
endif

if PluginEnabled('vim-latex-suite')
	let g:tex_flavor='latex'
	let g:Tex_DefaultTargetFormat='pdf'
	" imap <C-f> <Plug>IMAP_JumpForward
	" map <C-f> <Plug>IMAP_JumpForward
endif

if PluginEnabled('nerdcommenter')
	let g:NERDSpaceDelims=1
	let g:NERDCustomDelimiters={
		\ 'c':{'left':'//'},
		\ 'python':{'left':'#'},
		\} " requires C99
endif

if PluginEnabled('nerdtree')
	nnoremap <leader>n :NERDTreeToggle<CR>
endif

if PluginEnabled('rainbow')
	let s:paren_colors=['red', 'darkcyan', 'lightyellow', 'darkgreen', 'lightblue', 'brown', 'darkmagenta', 'gray']
	let g:rainbow_active=1
	let g:rainbow_conf={
		\ 'guifgs': s:paren_colors,
		\ 'ctermfgs': s:paren_colors,
		\ 'operators': '_,_',
		\ 'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
		\ 'separately': {
		\  '*': 0,
		\  'clojure': {},
		\  'lisp': {},
		\  'scheme': {},
		\ }
		\}
endif

if PluginEnabled('vim-sleuth')
	let g:sleuth_heuristics=1
endif

if PluginEnabled('tagbar')
	let g:tagbar_sort=0
	nnoremap <leader>te :TagbarOpen fj<CR>
endif

if PluginEnabled('YouCompleteMe')
	" Interpreter python priority:
	"   1) g:ycm_python_interpreter_path
	"   2) search for .venv in parent directories
	"   3) g:ycm_default_python_interpreter_path
	let g:ycm_python_interpreter_path='' " custom
	let g:default_ycm_python_interpreter_path='' " custom
	let s:pyenv_binary=$HOME.'/.pyenv/shims/python'
	if filereadable(s:pyenv_binary)
		let g:default_ycm_python_interpreter_path=s:pyenv_binary
	endif
	let g:ycm_python_system_path='' " custom
	let g:ycm_compilation_database_directory='' " custom, suffix directories to search
	let g:ycm_confirm_extra_conf=1
	let g:ycm_extra_conf_globlist=[]
	let g:ycm_extra_conf_vim_data=[
				\ 'g:ycm_python_interpreter_path',
				\ 'g:ycm_python_system_path',
				\ 'g:ycm_compilation_database_directory',
				\ 'v:version',
				\ '&filetype',
				\]
	let g:ycm_global_ycm_extra_conf=g:vimpath.'/.ycm_extra_conf.py'
	let g:ycm_disable_signature_help=1
	let g:ycm_always_populate_location_list=1
	let g:ycm_auto_hover=''
	let g:ycm_seed_identifiers_with_syntax=1
	let g:ycm_disable_for_files_larger_than_kb=10000
	let g:ycm_collect_identifiers_from_tag_files=1
	let g:ycm_collect_identifiers_from_comments_and_strings=1
	let g:ycm_filetype_blacklist={
		\ 'tagbar' : 1,
		\ 'qf' : 1,
		\ 'notes' : 1,
		\ 'markdown' : 1,
		\ 'unite' : 1,
		\ 'text' : 1,
		\ 'vimwiki' : 1,
		\ 'pandoc' : 1,
		\ 'infolog' : 1,
		\ 'mail' : 1,
		\ 'tex' : 1
		\}
	nnoremap <leader>f :YcmCompleter GoTo<CR>
	nnoremap <leader>r :YcmCompleter GoToReferences<CR>
	nnoremap <leader>h :YcmCompleter GetDoc<CR>
	nnoremap <leader>x :YcmCompleter FixIt<CR>
endif

" Config
if has("patch-7.4.338")
	let &showbreak='....'
	set breakindent
	set breakindentopt=shift:0
endif
set backupcopy=yes
set fileformats=unix,dos
set nofixendofline
set number
set showcmd cmdheight=2
set tabstop=2 shiftwidth=2
set nojoinspaces
set linebreak
set scrolloff=8 sidescrolloff=8
set nomodeline
set ruler
set backspace=indent,eol,start
set display=lastline,uhex
set whichwrap+=<,>,[,]
set wildmenu wildmode=list,full
let mapleader="\\"
set splitbelow splitright
set diffopt+=vertical
set history=100
set directory=~/tmp//,~/tmp,/var/tmp,.,/tmp

" Searching
set incsearch hlsearch
nnoremap <silent><Space> :noh<CR>
vnoremap <silent><Space> <Esc>:noh<CR>gv

" Config
filetype plugin indent on
syntax on
set formatoptions+=ro
set cinoptions=:0,ls,g0,N-s,(s,u0,m1
set nofoldenable foldmethod=indent " foldmethod=syntax slows vim considerably
set visualbell t_vb=
autocmd GUIEnter * set t_vb=
set mouse=
set notimeout ttimeout ttimeoutlen=0

" Font
if &t_Co==256
	set cursorline
	highlight CursorLine cterm=NONE ctermbg=236 " 236=Gray19
	highlight CursorLineNr cterm=NONE ctermbg=236 " 236=Gray19
	highlight LineNr ctermbg=238 " 238=Gray27
endif
if has('unix')
	set guifont=Lucida\ Console\ 11
endif
if has('win32')
	set guifont=Lucida_Console:h11
endif

" Spell
set spelllang=en_us
exec 'set spellfile='.g:vimpath.'/spell/en.utf-8.add'

" Shell
set shellslash
set grepprg=grep\ -nH\ $*
let $ZSH_ENV = g:vimpath.'/env.zsh'

" Remaps
"" Save and Quit
command! -bang Q q<bang>
command! -bang Qa qa<bang>
command! -bang QA qa<bang>
command! W w
command! Wq wq
command! WQ wq
command! -bang E e<bang>
"" Movement
noremap <Up> gk
noremap <Down> gj
noremap <Home> g<Home>
noremap <End> g<End>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <M-b> <S-Left>
cnoremap <M-f> <S-Right>
