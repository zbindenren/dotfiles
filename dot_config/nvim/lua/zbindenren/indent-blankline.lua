local ok, blankline = pcall(require, "ibl")
if not ok then
	vim.notify("indent-blankline plugin not found!")
	return
end

blankline.setup({
	scope = {
		enabled = false,
	},
})
