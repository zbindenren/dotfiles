local ok, blankline = pcall(require, "indent_blankline")
if not ok then
	vim.notify("indent-blankline plugin not found!")
	return
end

blankline.setup({
	buftype_exclude = { "terminal" },
})
