local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable', -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
	spec = {
		'folke/tokyonight.nvim',
		'Lokaltog/vim-easymotion',
		'bkad/CamelCaseMotion',
		'embear/vim-localvimrc',
		'jpalardy/vim-slime',
		'luochen1990/rainbow',
		'scrooloose/nerdcommenter',
		'terryma/vim-multiple-cursors',
		'tpope/vim-fugitive',
		'tpope/vim-rhubarb',
		'tpope/vim-sleuth',
		'tpope/vim-surround',
		'tpope/vim-unimpaired',
		'vim-airline/vim-airline',
		'vim-airline/vim-airline-themes',
		{'junegunn/fzf.vim', dependencies = { 'junegunn/fzf' }},

		{'VonHeikemen/lsp-zero.nvim', branch = 'v3.x'},
		'williamboman/mason.nvim',
		'williamboman/mason-lspconfig.nvim',
		'neovim/nvim-lspconfig',
		'hrsh7th/cmp-nvim-lsp',
		'hrsh7th/nvim-cmp',

		{
			'Exafunction/codeium.vim',
			enable = true,
			keys = {
				{ '<C-o>', mode='n'},
				{ '<C-o>', mode='i'},
			},
			config = function()
				vim.cmd('CodeiumEnable')
				vim.g.codeium_disable_bindings = 1
				vim.keymap.set('i', '<Tab>', function () return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
				vim.keymap.set('i', '<C-o>', function() return vim.fn['codeium#CycleOrComplete']() end, { expr = true, silent = true })
				vim.keymap.set('i', '<C-l>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true, silent = true })
				vim.keymap.set('i', '<C-Space>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
			end
		},
	},
	colorscheme = 'tokyonight',
	ui = {
		icons = {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})

local lsp_zero = require('lsp-zero')
lsp_zero.on_attach(function(client, bufnr)
	lsp_zero.default_keymaps({buffer = bufnr})
end)

require('mason').setup({})
require('mason-lspconfig').setup({
	ensure_installed = {
		'bashls',
		'clangd',
		'cmake',
		'cssls',
		'dockerls',
		-- 'gopls',
		'jdtls',
		'jsonls',
		'lua_ls',
		'pyright',
		'ruff',
		'rust_analyzer',
		'tsserver',
		'yamlls',
	},
	handlers = {
		function(server_name)
			require('lspconfig')[server_name].setup({})
		end,
		lua_ls = function()
			local lua_opts = lsp_zero.nvim_lua_ls()
			require('lspconfig').lua_ls.setup(lua_opts)
		end,
	}
})

local cmp = require('cmp')
local cmp_format = lsp_zero.cmp_format()

cmp.setup({
	formatting = cmp_format,
	mapping = cmp.mapping.preset.insert({
		-- scroll up and down the documentation window
		['<C-u>'] = cmp.mapping.scroll_docs(-4),
		['<C-d>'] = cmp.mapping.scroll_docs(4),
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({ select = false }),
	}),
	snippet = {
		expand = function(args)
			require('luasnip').lsp_expand(args.body)
		end,
	},
})
vim.keymap.set('i', '<C-e>', "<Cmd>lua require('cmp').complete()<CR>")

vim.cmd('source ' .. vim.fn.stdpath('config') .. '/init2.vim')
