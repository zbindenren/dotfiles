local ngit_status_ok, ngit = pcall(require, "neogit")
if not ngit_status_ok then
	vim.notify("neogit plugin not found!")
	return
end

ngit.setup({
	disable_commit_confirmation = true,
	integrations = {
		diffview = true,
	},
})
