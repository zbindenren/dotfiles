local status_ok, yode = pcall(require, "yond-nvim")
if not status_ok then
	vim.notify("yode plugin not found!")
	return
end

yode.setup({})
