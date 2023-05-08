local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	vim.notify("null-ls not found!")
	return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup({
	debug = false,
  timeout_ms = 20000,
	sources = {
		formatting.stylua,
		-- formatting.goimports,
		diagnostics.eslint,
		diagnostics.puppet_lint,
		diagnostics.golangci_lint,
		formatting.prettier,
		formatting.terraform_fmt,
		diagnostics.puppet_lint,
		formatting.trim_whitespace.with({
			disabled_filetypes = { "go" },
		}),
		formatting.trim_newlines.with({
			disabled_filetypes = { "go" },
		}),
	},
	on_attach = function(client)
		if client.server_capabilities.document_formatting and not vim.api.nvim_win_get_option(0, "diff") then
			vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
		end
	end,
})
