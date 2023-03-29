local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
	vim.notify("nvim-tree plugin not found!")
	return
end

nvim_tree.setup({
	diagnostics = {
		enable = true,
	},
  reload_on_bufenter = true,
})
