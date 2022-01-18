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
