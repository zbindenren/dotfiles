local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
	vim.notify("lspconfig not found!")
	return
end

require("zbindenren.lsp.mason")
require("zbindenren.lsp.handlers").setup()

local fidget_ok, fidget = pcall(require, "fidget")
if not fidget_ok then
	vim.notify("fidget not found!")
	return
end

fidget.setup()
