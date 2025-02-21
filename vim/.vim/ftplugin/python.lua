vim.g.python_indent = {
	disable_parentheses_indenting = false,
	closed_paren_align_last_line = false,
	searchpair_timeout = 150,
	continue = 'shiftwidth() * 2',
	open_paren	= 'shiftwidth()',
	nested_paren = 'shiftwidth()',
}
-- disable pyright diagnostics for unreachable code
vim.api.nvim_set_hl(0, 'DiagnosticUnnecessary', { fg = 'none', bg = 'none' })
