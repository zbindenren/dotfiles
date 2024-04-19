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
    templ = { "templ" },
    javascript = { { "prettierd", "prettier" } },
    html = { { "djlint" } },
    markdown = { { "markdownlint" } },
  },
  format_on_save = function(bufnr)
    -- Disable with a global or buffer-local variable
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    return { timeout_ms = 500, lsp_fallback = true }
  end,
})
