return {
  "akinsho/git-conflict.nvim",
  lazy = false,
  opts = {
    default_mappings = {
      ours = "<leader>gho",
      theirs = "<leader>ght",
      none = "<leader>gh0",
      both = "<leader>ghb",
      next = "]x",
      prev = "[x",
    },
  },
  keys = {
    {
      "<leader>ghx",
      "<cmd>GitConflictListQf<cr>",
      desc = "List Conflicts",
    },
    {
      "<leader>ghr",
      "<cmd>GitConflictRefresh<cr>",
      desc = "Refresh Conflicts",
    },
  },
}
