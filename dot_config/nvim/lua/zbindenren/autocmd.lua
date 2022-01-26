-- Autocommands
-- restore cursor position
vim.cmd([[
  augroup RestoreCursorPosition
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
  augroup end
]])

-- apply chezmoi on write
vim.cmd([[
  augroup ApplyChezmoi
    autocmd!
    autocmd BufWritePost ~/.local/share/chezmoi/* ! chezmoi apply --source-path "%"
  augroup end
]])

-- oscyank
vim.cmd([[
  augroup OSCYank
    autocmd!
    autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '+' | execute 'OSCYankReg +' | endif
  augroup end
]])

-- vim.cmd([[
--   augroup AutoSaveOnInsertLeave
--     autocmd!
--     autocmd InsertLeave * ++nested write
--   augroup end
-- ]])