local home = os.getenv("HOME")

return {
  {
    -- "zbindenren/le-grand-bleu.nvim",
    dir = home .. "/repos/github.com/zbindenren/le-grand-bleu",
    opts = {},
  },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "le-grand-bleu",
    },
  },
}
