-- load packer on all machines
local fn = vim.fn

local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
	fn.system({ "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path })
	execute("packadd packer.nvim")
end

require("zbindenren.options")
require("zbindenren.keymaps")
require("zbindenren.whichkey")
require("zbindenren.plugins")
require("zbindenren.colorscheme")

vim.api.nvim_command("set noswapfile") -- I have OCD file saving issues anyway

-- restore cursor position
vim.cmd([[
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
]])

-- recompile automatically when editing plugins.lua
vim.cmd([[
autocmd BufWritePost plugins.lua PackerCompile
]])

-- apply chezmoi on write
vim.cmd([[
autocmd BufWritePost ~/.local/share/chezmoi/* ! chezmoi apply --source-path "%"
]])

vim.cmd([[
autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '+' | execute 'OSCYankReg +' | endif
]])

vim.cmd([[
autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()
]])

-- set test strategy to vimux
vim.g["test#strategy"] = "vimux"

-- nvim.tree settings
vim.g.nvim_tree_width = "15%"

-- symbols settings
vim.g.symbols_outline = {
	auto_close = true,
}

-- load other lua configurations
-- require("plugins")
-- require("mappings")
require("go")
require("statusline")
require("markdown")
require("lsp")
