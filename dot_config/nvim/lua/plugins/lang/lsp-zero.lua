local status_ok, lsp_zero = pcall(require, 'lsp-zero')
if not status_ok then
  return
end

local navic = require("nvim-navic")

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({
    buffer = bufnr,
    preserve_mappings = false,
  })

  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end
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
    lua_ls = function()
      local lua_opts = lsp_zero.nvim_lua_ls()
      require('lspconfig').lua_ls.setup(lua_opts)
    end,
    gopls = function()
      require('lspconfig').gopls.setup({
        settings = {
          gopls = {
            gofumpt = true,
          },
        },
      })
    end
  },
})

local fidget_ok, fidget = pcall(require, "fidget")
if not fidget_ok then
  vim.notify("fidget not found!")
  return
end

fidget.setup()


local signs = {
  { name = "DiagnosticSignError", text = "" },
  { name = "DiagnosticSignWarn", text = "" },
  { name = "DiagnosticSignHint", text = "" },
  { name = "DiagnosticSignInfo", text = "" },
}


for _, sign in ipairs(signs) do
  vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end

local config = {
  -- disable virtual text
  virtual_text = true,
  -- show signs
  signs = {
    active = signs,
  },
}

vim.diagnostic.config(config)
