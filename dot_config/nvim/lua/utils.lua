-- https://bryankegley.me/posts/nvim-getting-started/
--
local M = {}

-- Thanks teej!
M.key_mapper = function(mode, key, result)
	-- use nvim_buf_set_keymap instead to allow buftype specific keymaps
	-- this isn't currently working however
	-- vim.api.nvim_buf_set_keymap('%', mode, key, result, {noremap = true, silent = true})
	-- use vim.api.nvim_buf_get_option(0, 'filetype') to check filetype
	vim.api.nvim_set_keymap(mode, key, result, { noremap = true, silent = true })
end

M.toggleNum = function()
	vim.cmd("Gitsigns toggle_signs")
	if vim.o.number then
		vim.opt.number = false
		vim.opt.relativenumber = false
	else
		vim.opt.number = true
		vim.opt.relativenumber = true
	end
end

M.toggleClipboard = function()
	if vim.o.clipboard == "unnamedplus" then
		vim.o.clipboard = "unnamed"
		vim.notify("set clipboard to unamed")
	else
		vim.o.clipboard = "unnamedplus"
		vim.notify("set clipboard to unamedplus (default)")
	end
end

M.copyLineInfo = function()
	local lineName = vim.fn.expand("%")
	local lineNumber = vim.fn.line(".")
	return lineName .. ":" .. lineNumber
end

return M
