vim.opt.background = "light"
vim.g.zenwritten = {
    lightness = "bright",
    darken_noncurrent_window = true,
}

local colorscheme = "zenwritten"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
    vim.notify("colorscheme " .. colorscheme .. " not found!")

    return
end
