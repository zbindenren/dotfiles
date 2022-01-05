local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
	vim.notify("lspconfig not found!")
	return
end

require("zbindenren.lsp.lsp-installer")
require("zbindenren.lsp.handlers").setup()
-- require("zbindenren.lsp.null-ls")
