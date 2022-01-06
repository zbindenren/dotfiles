local opts = { noremap = true, silent = true }
local opts_expr = { noremap = true, silent = true, expr = true }
local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

-- set space as new leader
keymap("", "<space>", "<nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Normal
-- nvimtree
keymap("n", "<c-b>", ":NvimTreeToggle<cr>", opts)
keymap("n", "<leader><leader>f", ":NvimTreeFindFile<cr>", opts)

-- neozoom
-- keymap("n", "<cr>", ":NeoZoomToggle<cr>", opts)
keymap("n", "<leader>z", ":NeoZoomToggle<cr>", opts)

-- resize windows
keymap("n", "<a-up>", "<cmd>resize -2<cr>", opts)
keymap("n", "<a-down>", "<cmd>resize +2<cr>", opts)
keymap("n", "<a-right>", "<cmd>vertical resize -2<cr>", opts)
keymap("n", "<a-left>", "<cmd>vertical resize +2<cr>", opts)

-- mergetool
keymap("n", "<c-left>", '&diff? "<plug>(MergetoolDiffExchangeLeft)" : "\\<c-left>"', { expr = true })
keymap("n", "<c-right>", '&diff? "<plug>(MergetoolDiffExchangeRight)" : "\\<c-right>"', { expr = true })
keymap("n", "<c-up>", '&diff? "<plug>(MergetoolDiffExchangeUp)" : "\\<c-up>"', { expr = true })
keymap("n", "<c-down>", '&diff? "<plug>(MergetoolDiffExchangeDown)" : "\\<c-down>"', { expr = true })
keymap("n", "<up>", '&diff ? "[c" : "<up>"', { expr = true })
keymap("n", "<down>", '&diff ? "]c" : "<down>"', { expr = true })

-- Insert
-- jj as <esc>
keymap("i", "jj", "<esc>", opts)

-- code completion
keymap("i", "<cr>", "compe#confirm('<cr>')", opts_expr)
keymap("i", "<c-j>", 'pumvisible() ? "\\<c-n>" : "\\<c-j>"', opts_expr)
keymap("i", "<c-k>", 'pumvisible() ? "\\<c-p>" : "\\<c-j>"', opts_expr)
keymap("i", "<c-space>", "compe#complete()", opts_expr)

-- Visual
-- OSCYank
keymap("v", "<leader>y", ":OSCYank<cr>", opts)

-- Shift + J/K moves selected lines down/up in visual mode
keymap("v", "J", ":m '>+1<CR>gv=gv", opts)
keymap("v", "K", ":m '<-2<CR>gv=gv", opts)

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- EasyAlign
keymap("n", "ga", "<plug>(EasyAlign)", opts)
keymap("x", "ga", "<plug>(EasyAlign)", opts)

-- Autocommands
-- restore cursor position
vim.cmd([[
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
]])

-- apply chezmoi on write
vim.cmd([[
autocmd BufWritePost ~/.local/share/chezmoi/* ! chezmoi apply --source-path "%"
]])

-- oscyank
vim.cmd([[
autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '+' | execute 'OSCYankReg +' | endif
]])

-- lightbulp
vim.cmd([[
autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()
]])

-- set test strategy to vimux
vim.g["test#strategy"] = "vimux"

-- nvim.tree settings
vim.g.nvim_tree_width = "15%"

-- symbols settings
vim.g.symbols_outline = {
	auto_close = true,
}
