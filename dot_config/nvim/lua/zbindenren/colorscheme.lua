vim.opt.background = "light"
vim.g.zenbones = {
	lightness = "bright",
	darken_noncurrent_window = true,
}

-- local colorscheme = "tokyonight"
local colorscheme = "zenbones"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
	vim.notify("colorscheme " .. colorscheme .. " not found!")
	return
end
