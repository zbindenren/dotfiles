local status_ok, conform = pcall(require, "conform")

if not status_ok then
	vim.notify("conform plugin not found!")
	return
end

conform.setup({
	formatters = {
		templ = {
			command = "templ",
			args = { "fmt" },
		},
	},
	formatters_by_ft = {
		lua = { "stylua" },
		templ = { "templ" },
		javascript = { { "prettierd", "prettier" } },
		html = { { "djlint" } },
	},
	format_on_save = {
		-- These options will be passed to conform.format()
		timeout_ms = 500,
		lsp_fallback = true,
	},
})
