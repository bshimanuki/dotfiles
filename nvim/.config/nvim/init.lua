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
	{
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
		config = function()
			require('nvim-treesitter.configs').setup({
				ensure_installed = 'all',
				highlight = {
					enable = true,
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = 'gn',
						scope_incremental = '<CR>',
						node_incremental = '<TAB>',
						node_decremental = '<S-TAB>',
					},
				}
			})
		end
	},
	'RRethy/vim-illuminate',
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
	'L3MON4D3/LuaSnip',

	-- {
		-- 'Exafunction/codeium.vim',
		-- enable = true,
		-- keys = {
			-- { '<leader>o', mode='n'},
			-- { '<C-o>', mode='i'},
		-- },
		-- cmd = 'CodeiumEnable',
		-- config = function()
			-- vim.cmd('CodeiumEnable')
			-- vim.keymap.set('i', '<Tab>', function () return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
			-- vim.keymap.set('i', '<S-Tab>', function () return vim.fn['codeium#AcceptNextWord']() end, { expr = true, silent = true })
			-- vim.keymap.set('i', '<C-]>', function ()
				-- local value = vim.fn['codeium#AcceptNextLine']()
				-- if value:match('^%s*$') then value = '' end
				-- return value .. vim.api.nvim_replace_termcodes('<CR>', true, false, true)
			-- end, { expr = true, silent = true })
			-- vim.keymap.set('i', '<C-o>', function() return vim.fn['codeium#CycleOrComplete']() end, { expr = true, silent = true })
			-- vim.keymap.set('i', '<C-l>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true, silent = true })
			-- vim.keymap.set('i', '<C-Space>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
		-- end
	-- },
	{
		'bshimanuki/neocodeium',
		config = function()
			local neocodeium = require('neocodeium')
			neocodeium.setup({
				enabled = false,
				server = {
					chat_web_server_port = os.getenv('NEOCODEIUM_CHAT_WEB_SERVER_PORT'),
					chat_client_port = os.getenv('NEOCODEIUM_CHAT_CLIENT_PORT'),
					chat_enabled = true,
				},
				silent = true,
			})
			vim.keymap.set('i', '<Tab>', neocodeium.accept)
			vim.keymap.set('i', '<S-Tab>', neocodeium.accept_word)
			vim.keymap.set('i', '<C-]>', neocodeium.accept_line)
			vim.keymap.set('i', '<C-o>', neocodeium.cycle_or_complete)
			vim.keymap.set('i', '<C-l>', function() neocodeium.cycle_or_complete(-1) end)
			vim.keymap.set('i', '<C-Space>', neocodeium.clear)
			vim.keymap.set('n', '<leader>o', neocodeium.chat)
		end,
	},
}
vim.g.codeium_disable_bindings = 1

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
			cmd = '⌘',
			config = '🛠',
			event = '📅',
			ft = '📂',
			init = '⚙',
			keys = '🗝',
			plugin = '🔌',
			runtime = '💻',
			require = '🌙',
			source = '📄',
			start = '🚀',
			task = '📌',
			lazy = '💤 ',
		},
	},
})

-- Language Server Protocol
local lsp_zero = require('lsp-zero')
lsp_zero.on_attach(function(client, bufnr)
	lsp_zero.default_keymaps({
		buffer = bufnr,
		exclude = { 'gi' },
	})
	vim.keymap.set('n', 'gR', vim.lsp.buf.implementation)
end)
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>w', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end)

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
vim.keymap.set('i', '<C-e>', '<Cmd>lua require("cmp").complete()<CR>')

-- Other plugins
require('aerial').setup({
	backends = { 'lsp', 'treesitter', 'markdown', 'asciidoc', 'man' },
	attach_mode = 'global',
	layout = {
		default_direction = 'right',
		placement = 'edge',
		preserve_equality = true,
	},
})
vim.keymap.set('n', '<leader>a', ':AerialOpen<CR>')
vim.keymap.set('n', '[c', ':AerialPrev<CR>')
vim.keymap.set('n', ']c', ':AerialNext<CR>')


-- Source common settings between vim and neovim
vim.cmd('source ' .. vim.g.vimpath .. '/common.vim')

-- Source other vimscript settings
vim.cmd('source ' .. vim.fn.stdpath('config') .. '/init2.vim')
