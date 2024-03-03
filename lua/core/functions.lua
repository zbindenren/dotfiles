-- Reload neovim config
vim.api.nvim_create_user_command('ReloadConfig', function()
  for name, _ in pairs(package.loaded) do
    if name:match('^plugins') then
      package.loaded[name] = nil
    end
  end

  dofile(vim.env.MYVIMRC)
  vim.notify('Nvim configuration reloaded!', vim.log.levels.INFO)
end, {})

-- Copy relative path
vim.api.nvim_create_user_command('CRpath', function()
  local path = vim.fn.expand('%')
  vim.fn.setreg('+', path)
  vim.notify('Copied "' .. path .. '" to the clipboard!')
end, {})

-- Copy absolute path
vim.api.nvim_create_user_command('CApath', function()
  local path = vim.fn.expand('%:p')
  vim.fn.setreg('+', path)
  vim.notify('Copied "' .. path .. '" to the clipboard!')
end, {})


vim.api.nvim_create_user_command('ToggleNum', function()
  vim.cmd("Gitsigns toggle_signs")
  if vim.o.number then
    vim.opt.number = false
    vim.opt.relativenumber = false
  else
    vim.opt.number = true
    vim.opt.relativenumber = true
  end
end, {})

vim.api.nvim_create_user_command('ToggleClipboard', function()
  if vim.o.clipboard == "unnamedplus" then
    vim.o.clipboard = "unnamed"
    vim.notify("set clipboard to unamed")
  else
    vim.o.clipboard = "unnamedplus"
    vim.notify("set clipboard to unamedplus (default)")
  end
end, {})
