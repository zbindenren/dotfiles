-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set
local mouse = require("config.utils.mouse")
local comment = require("config.utils.comment")

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ Gitlab ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
map("n", "<leader>gp", function()
  Snacks.terminal("lab open -p; sleep 1")
end, { desc = "Open Git Project Pipeline in Browser" })

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ Mouse ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
map("n", "<leader>uM", mouse.toggle_mouse, { desc = "Toggle Mouse" })

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ Comment Header ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
map("n", "<leader>cH", comment.create_comment_header, { desc = "Create Comment Header" })
map("n", "]k", comment.find_next_comment_header, { desc = "Next Comment Header" })
map("n", "[k", comment.find_previous_comment_header, { desc = "Previous Comment Header" })
