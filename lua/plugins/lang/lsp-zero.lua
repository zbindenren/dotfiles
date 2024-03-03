local status_ok, lsp_zero = pcall(require, 'lsp-zero')
if not status_ok then
    return
end

lsp_zero.on_attach(function(_, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({
    buffer = bufnr,
    preserve_mappings = false,
  })
end
)

local installed_servers = require('plugins.list').lsp_servers

-- to learn how to use mason.nvim with lsp-zero
-- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guide/integrate-with-mason-nvim.md
require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = installed_servers,
  handlers = {
    lsp_zero.default_setup,
  },
})

local fidget_ok, fidget = pcall(require, "fidget")
if not fidget_ok then
	vim.notify("fidget not found!")
	return
end

fidget.setup()
