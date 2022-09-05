local mason_ok, mason = pcall(require, "mason")
if not mason_ok then
	vim.notify("mason not found!")
	return
end

local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_ok then
	vim.notify("mason-lspconfig not found!")
	return
end

local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_ok then
	vim.notify("lspconfig not found!")
	return
end

local servers = {
	"sumneko_lua",
	"gopls",
	"yamlls",
}

mason.setup()
mason_lspconfig.setup({
	ensure_installed = servers,
})

for _, server in ipairs(servers) do
	local opts = {
		on_attach = require("zbindenren.lsp.handlers").on_attach,
		capabilities = require("zbindenren.lsp.handlers").capabilities,
	}

	local server_opts = require("zbindenren.lsp.settings." .. server)
	opts = vim.tbl_deep_extend("force", server_opts, opts)

	lspconfig[server].setup(opts)
end
