local o = vim.opt

o.expandtab = true -- Use spaces instead of tabs
o.shiftwidth = 2 -- Size of an indent
o.tabstop = 2 -- Number of spaces tabs count for
o.pumheight = 10 -- pop up menu height
o.smartindent = true -- Insert indents automatically
o.smartcase = true -- Don't ignore case with capitals
o.mouse = "" -- Disable mouse
o.clipboard = "unnamedplus" -- Put those yanks in my os clipboards
o.completeopt = "menuone,noselect" -- Completion options (for compe)
o.hidden = true -- Enable modified buffers in background
o.ignorecase = true -- Ignore case
o.incsearch = true -- Make search behave like modern browsers
o.undofile = true -- enable persistent undo
o.updatetime = 300 -- faster completion (4000ms default)
o.inccommand = "split" -- Live preview for search and replace
o.joinspaces = false -- No double spaces with join after a dot
o.signcolumn = "yes" -- always show the sign column, otherwise it would shift the text each time
o.showmode = false -- we don't need to see things like -- INSERT -- anymore
o.scrolloff = 10 -- Lines of context
o.shiftround = true -- Round indent
o.sidescrolloff = 8 -- Columns of context
o.splitbelow = true -- Put new windows below current
o.splitright = true -- Put new windows right of current
o.termguicolors = true -- True color support
o.wildmode = "list:longest" -- Command-line completion mode
o.list = false -- Show some invisible characters (tabs...)
o.number = true -- Print line number
o.relativenumber = true -- Relative line numbers
o.wrap = true -- Enable line wrap
o.cmdheight = 2 -- More space to display messages
o.timeoutlen = 150 -- Don't wait more that 150ms for normal mode commands
o.termguicolors = true -- True color support
o.shada = { "!", "'1000", "<50", "s10", "h" } -- remember stuff across sessions

vim.opt.shortmess:append("c")

-- colorscheme settings
vim.g.nord_contrast = true
vim.g.nord_borders = true
vim.g.tokyonight_style = "night"

vim.cmd([[set iskeyword+=-]]) -- this treats dash separated words (i.e: dash-separated) as one word
vim.cmd([[set whichwrap+=<,>,[,],h,l]]) -- this causes the h and l key to wrap when used at beginning or end of lines
