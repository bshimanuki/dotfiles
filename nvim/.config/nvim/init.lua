local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable',
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
	'Exafunction/codeium.vim',
	enable = true,
	keys = {
		{ '<C-N>', mode='n'},
		{ '<C-N>', mode='i'},
	},
	config = function()
		vim.cmd('CodeiumEnable')
		vim.g.codeium_disable_bindings = 1
    vim.keymap.set('i', '<Tab>', function () return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
    vim.keymap.set('i', '<C-N>', function() return vim.fn['codeium#CycleOrComplete']() end, { expr = true, silent = true })
    vim.keymap.set('i', '<C-P>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true, silent = true })
    vim.keymap.set('i', '<C-Space>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
	end
})

vim.cmd('source ' .. vim.fn.stdpath('config') .. '/init2.vim')
