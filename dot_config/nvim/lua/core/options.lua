local options = {
  expandtab = true,                            -- Use spaces instead of tabs
  shiftwidth = 2,                              -- Size of an indent
  tabstop = 2,                                 -- Number of spaces tabs count for
  pumheight = 10,                              -- pop up menu height
  smartindent = true,                          -- Insert indents automatically
  smartcase = true,                            -- Don't ignore case with capitals
  mouse = "",                                  -- Disable mouse
  autoread = true,                             -- Reload file after it changes on disk.
  clipboard = "unnamedplus",                   -- Put those yanks in my os clipboards
  hidden = true,                               -- Enable modified buffers in background
  ignorecase = true,                           -- Ignore case
  incsearch = true,                            -- Make search behave like modern browsers
  undofile = true,                             -- enable persistent undo
  updatetime = 300,                            -- faster completion (4000ms default)
  inccommand = "split",                        -- Live preview for search and replace
  joinspaces = false,                          -- No double spaces with join after a dot
  signcolumn = "yes",                          -- always show the sign column, otherwise it would shift the text each time
  showmode = false,                            -- we don't need to see things like -- INSERT -- anymore
  scrolloff = 8,                               -- Lines of context
  shiftround = true,                           -- Round indent
  sidescrolloff = 8,                           -- Columns of context
  splitbelow = true,                           -- Put new windows below current
  splitright = true,                           -- Put new windows right of current
  termguicolors = true,                        -- True color support
  --wildmode = "list:longest", -- Command-line completion mode
  list = false,                                -- Show some invisible characters (tabs...)
  swapfile = false,                            -- creates a swapfile
  listchars = { trail = "", tab = "", nbsp = "_", extends = ">", precedes = "<" },
  number = true,                               -- Print line number
  relativenumber = true,                       -- Relative line numbers
  wrap = true,                                 -- Enable line wrap
  cmdheight = 1,                               -- More space to display messages
  timeoutlen = 300,                            -- Don't wait more that 150ms for normal mode commands
  shada = { "!", "'1000", "<50", "s10", "h" }, -- remember stuff across sessions
  confirm = true,                              -- when you leave a file and didn't save, you just just hit y or n or save or leave it untouched
  laststatus = 3,
  -- folds
  foldmethod = "expr",
  foldexpr = "nvim_treesitter#foldexpr()",
  foldlevelstart = 99,
  foldnestmax = 1,
}

vim.cmd([[
     setlocal spell spelllang=en "Set spellcheck language to en
     setlocal spell! "Disable spell checks by default
     filetype plugin indent on
     if has('win32')
        let g:python3_host_prog = $HOME . '/scoop/apps/python/current/python.exe'
     endif
 ]])

vim.opt.path:append({ "**" })

-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

vim.opt.shortmess:append({ W = true, I = true, c = true })

if vim.fn.has("nvim-0.9.0") == 1 then
  vim.opt.splitkeep = "screen"
  vim.opt.shortmess:append({ C = true })
end

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

for k, v in pairs(options) do
  vim.opt[k] = v
end
