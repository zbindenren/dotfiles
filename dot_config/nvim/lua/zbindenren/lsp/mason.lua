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
	"gopls",
	"yamlls",
	"jsonls",
	"lua_ls",
	-- "templ",
}

mason.setup()
mason_lspconfig.setup({
	ensure_installed = servers,
})

local opts = {
	on_attach = require("zbindenren.lsp.handlers").on_attach,
	capabilities = require("zbindenren.lsp.handlers").capabilities,
}

for _, server in ipairs(servers) do
	local server_opts = require("zbindenren.lsp.settings." .. server)
	opts = vim.tbl_deep_extend("force", server_opts, opts)
end

for _, server in ipairs(servers) do
	lspconfig[server].setup(opts)
end

local util = require("lspconfig.util")
local configs = require("lspconfig.configs")

-- Check if the config is already defined (useful when reloading this file)
if not configs.templ then
	configs.templ = {
		default_config = {
			cmd = { "templ", "lsp" },
			filetypes = { "templ" },
			root_dir = util.root_pattern("go.mod", ".git"),
			--[[ root_dir = function(fname)
				return lspconfig.util.find_git_ancestor(fname)
			end, ]]
			settings = {},
		},
	}
end

lspconfig["templ"].setup(opts)
