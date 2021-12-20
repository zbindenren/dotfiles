-- load packer on all machines
local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
	fn.system({ "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path })
	execute("packadd packer.nvim")
end

local indent = 2
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.shiftwidth = indent -- Size of an indent
vim.opt.smartindent = true -- Insert indents automatically
vim.opt.tabstop = indent -- Number of spaces tabs count for
vim.opt.mouse = "" -- Disable mouse
vim.opt.clipboard = "unnamedplus" -- Put those yanks in my os clipboards
vim.opt.completeopt = "menuone,noselect" -- Completion options (for compe)
vim.opt.hidden = true -- Enable modified buffers in background
vim.opt.ignorecase = true -- Ignore case
vim.opt.incsearch = true -- Make search behave like modern browsers
vim.opt.inccommand = "split" -- Live preview for search and replace
vim.opt.joinspaces = false -- No double spaces with join after a dot
vim.opt.scrolloff = 10 -- Lines of context
vim.opt.shiftround = true -- Round indent
vim.opt.sidescrolloff = 8 -- Columns of context
vim.opt.smartcase = true -- Don't ignore case with capitals
vim.opt.splitbelow = true -- Put new windows below current
vim.opt.splitright = true -- Put new windows right of current
vim.opt.termguicolors = true -- True color support
vim.opt.wildmode = "list:longest" -- Command-line completion mode
vim.opt.list = false -- Show some invisible characters (tabs...)
vim.opt.number = true -- Print line number
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.wrap = true -- Enable line wrap
vim.opt.cmdheight = 2 -- More space to display messages
vim.opt.timeoutlen = 100 -- Don't wait more that 100ms for normal mode commands
vim.opt.termguicolors = true -- True color support
vim.opt.shada = { "!", "'1000", "<50", "s10", "h" } -- remember stuff across sessions
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
-- set leader to space early
vim.g.mapleader = " "

-- set test strategy to vimux
vim.g["test#strategy"] = "vimux"

-- nvim.tree settings
vim.g.nvim_tree_width = "10%"

-- symbols settings
vim.g.symbols_outline = {
	auto_close = true,
}

-- load other lua configurations
require("plugins")
require("mappings")
require("go")
require("statusline")
require("markdown")
require("lsp")

vim.cmd([[colorscheme dracula]])
