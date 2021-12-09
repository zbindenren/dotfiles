vim.cmd(([[
autocmd FileType markdown lua whichkeyMarkdown()
]]))

_G.whichkeyMarkdown = function()
  local wk = require("which-key")
  wk.register({
    m = {
      name = "Markdown",
      p = { "<cmd>Glow<cr>", "preview" },
    },
  }, { prefix = "<leader>" })
end
