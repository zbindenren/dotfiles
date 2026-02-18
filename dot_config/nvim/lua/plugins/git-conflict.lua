return {
  "akinsho/git-conflict.nvim",
  lazy = false,
  -- plugin's default commands pass <Plug> strings to nvim_create_user_command which
  -- expects a function or Ex command, causing E492 errors (broken as of v2.1.1)
  opts = {
    default_mappings = false,
    default_commands = false,
  },
  config = function(_, opts)
    local gc = require("git-conflict")
    gc.setup(opts)

    local map = vim.keymap.set
    local cmd = vim.api.nvim_create_user_command
    local mopts = function(desc) return { desc = "Git Conflict: " .. desc } end

    map({ "n", "v" }, "<leader>gxo", function() gc.choose("ours") end, mopts("Choose Ours"))
    map({ "n", "v" }, "<leader>gxt", function() gc.choose("theirs") end, mopts("Choose Theirs"))
    map({ "n", "v" }, "<leader>gx0", function() gc.choose("none") end, mopts("Choose None"))
    map({ "n", "v" }, "<leader>gxb", function() gc.choose("both") end, mopts("Choose Both"))
    map("n", "]x", function() gc.find_next("ours") end, mopts("Next Conflict"))
    map("n", "[x", function() gc.find_prev("ours") end, mopts("Prev Conflict"))

    cmd("GitConflictChooseOurs", function() gc.choose("ours") end, { nargs = 0 })
    cmd("GitConflictChooseTheirs", function() gc.choose("theirs") end, { nargs = 0 })
    cmd("GitConflictChooseNone", function() gc.choose("none") end, { nargs = 0 })
    cmd("GitConflictChooseBoth", function() gc.choose("both") end, { nargs = 0 })
    cmd("GitConflictChooseBase", function() gc.choose("base") end, { nargs = 0 })
    cmd("GitConflictNextConflict", function() gc.find_next("ours") end, { nargs = 0 })
    cmd("GitConflictPrevConflict", function() gc.find_prev("ours") end, { nargs = 0 })
  end,
}
