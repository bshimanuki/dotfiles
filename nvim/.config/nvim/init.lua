vim.g.vimpath = vim.fn.expand('$HOME/.vim')
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

local plugin_spec = {
	'folke/tokyonight.nvim',
	'Lokaltog/vim-easymotion',
	'bkad/CamelCaseMotion',
	'embear/vim-localvimrc',
	'jpalardy/vim-slime',
	{
		'klen/nvim-config-local',
		config = function()
			require('config-local').setup {
				lookup_parents = true,
			}
		end
	},
	'luochen1990/rainbow',
	'scrooloose/nerdcommenter',
	'stevearc/aerial.nvim',
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
			{ '<leader>o', mode='n'},
			{ '<C-o>', mode='i'},
		},
		cmd = 'CodeiumEnable',
		config = function()
			vim.cmd('CodeiumEnable')
			vim.g.codeium_disable_bindings = 1
			vim.keymap.set('i', '<Tab>', function () return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
			vim.keymap.set('i', '<C-o>', function() return vim.fn['codeium#CycleOrComplete']() end, { expr = true, silent = true })
			vim.keymap.set('i', '<C-l>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true, silent = true })
			vim.keymap.set('i', '<C-Space>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
		end
	},
}

local plugin_names = {}
for _, plugin in ipairs(plugin_spec) do
	-- Add plugin name after last slash to plugin_names
	if type(plugin) == 'table' then
		plugin = plugin[1]
	end
	local chunks = vim.split(plugin, '/')
	plugin_names[chunks[#chunks]] = plugin
end

-- Source common plugin settings before loading plugins
vim.g.PluginEnabled = function(name)
	return plugin_names[name] ~= nil
end
vim.cmd('source ' .. vim.g.vimpath .. '/common_before_plugins.vim')

require('lazy').setup({
	spec = plugin_spec,
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

-- Language Server Protocol
local lsp_zero = require('lsp-zero')
lsp_zero.on_attach(function(client, bufnr)
	lsp_zero.default_keymaps({buffer = bufnr})
end)
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float)

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
		'ruff_lsp',
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

-- Completion
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

-- Other plugins
require('aerial').setup({
	vim.keymap.set('n', '<leader>a', ':AerialToggle<CR>'),
})


-- Source common settings between vim and neovim
vim.cmd('source ' .. vim.g.vimpath .. '/common.vim')

-- Source other vimscript settings
vim.cmd('source ' .. vim.fn.stdpath('config') .. '/init2.vim')
