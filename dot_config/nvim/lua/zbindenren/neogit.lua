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

local group = vim.api.nvim_create_augroup('CloseNeoginOnPush', { clear = true })
vim.api.nvim_create_autocmd('User', {
  pattern = 'NeogitPushComplete',
  group = group,
	callback = ngit.close,
})
