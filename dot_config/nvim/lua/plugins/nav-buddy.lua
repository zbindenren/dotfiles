return {
  "neovim/nvim-lspconfig",
  keys = {
    {
      "<leader>cs",
      "<cmd>Navbuddy<cr>",
      desc = "Outline with Navbuddy",
    },
  },
  dependencies = {
    {
      "SmiteshP/nvim-navbuddy",
      dependencies = {
        "SmiteshP/nvim-navic",
        "MunifTanjim/nui.nvim",
      },
      opts = { lsp = { auto_attach = true } },
    },
  },
  -- your lsp config or other stuff
}
