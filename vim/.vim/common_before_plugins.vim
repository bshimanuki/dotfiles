" Plugin settings common between vim and neovim that need to be set before the
" plugin is loaded
if PluginEnabled('vim-localvimrc')
	" use `if g:localvimrc_sourced_once_for_file | finish | endif`
	" as an include guard
	let g:localvimrc_event=['BufNewFile', 'BufReadPre', 'BufWinEnter']
	let g:localvimrc_persistent=1
	let g:localvimrc_persistence_file=g:vimpath.'/.localvimrc_persistent'
endif

if PluginEnabled('vim-slime')
	let g:slime_target='tmux'
	let g:slime_default_config={'socket_name': 'default', 'target_pane': '0'}
	let g:slime_dont_ask_default=1
	let g:slime_no_mappings=1
	" let g:slime_python_ipython=1
	xmap <leader>s <Plug>SlimeRegionSend
	nmap <leader>s <Plug>SlimeMotionSend
	nmap <leader>ss <Plug>SlimeParagraphSend
	nmap <leader>sv <Plug>SlimeConfig
endif
