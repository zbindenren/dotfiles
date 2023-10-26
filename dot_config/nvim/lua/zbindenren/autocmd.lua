-- Autocommands
-- restore cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
	command = [[if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]],
	group = vim.api.nvim_create_augroup("RestoreCursorPosition", { clear = true }),
})

-- apply chezmoi on write
vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "*/dot_config/*",
	command = '! chezmoi apply --source-path "%"',
	group = vim.api.nvim_create_augroup("ApplyChezmoi", { clear = false }),
})

-- highlight yanked text for 200ms using the "Visual" highlight group
vim.api.nvim_create_autocmd("TextYankPost", {
	command = 'silent! lua vim.highlight.on_yank({higroup="Visual", timeout=200})',
	group = vim.api.nvim_create_augroup("HighlightYank", { clear = true }),
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.go" },
	callback = function()
		vim.lsp.buf.format({
      timeout_ms=3000
    })
	end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.go" },
	callback = require("utils").go_organize_imports_sync,
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    require("lint").try_lint()
  end,
})
