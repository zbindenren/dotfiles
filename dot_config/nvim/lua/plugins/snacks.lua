return {
  "folke/snacks.nvim",
  opts = {
    indent = {
      enabled = false,
    },
    picker = {
      win = {
        input = {
          keys = {
            ["<a-a>"] = { "toggle_hidden", mode = { "i", "n" } },
          },
        },
      },
    },
  },
}
