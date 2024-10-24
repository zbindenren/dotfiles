-- Reload neovim config
vim.api.nvim_create_user_command("ReloadConfig", function()
  for name, _ in pairs(package.loaded) do
    if name:match("^plugins") then
      package.loaded[name] = nil
    end
  end

  dofile(vim.env.MYVIMRC)
  vim.notify("Nvim configuration reloaded!", vim.log.levels.INFO)
end, {})

-- Copy relative path
vim.api.nvim_create_user_command("CRpath", function()
  local path = vim.fn.expand("%")
  vim.fn.setreg("+", path)
  vim.notify('Copied "' .. path .. '" to the clipboard!')
end, {})

-- Copy absolute path
vim.api.nvim_create_user_command("CApath", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify('Copied "' .. path .. '" to the clipboard!')
end, {})

-- Toggle line numbers.
vim.api.nvim_create_user_command("ToggleNum", function()
  vim.cmd("Gitsigns toggle_signs")
  if vim.o.number then
    vim.opt.number = false
    vim.opt.relativenumber = false
  else
    vim.opt.number = true
    vim.opt.relativenumber = true
  end
end, {})

-- Toggle list chars.
vim.api.nvim_create_user_command("ToggleList", function()
  if vim.o.list then
    vim.opt.list = false
  else
    vim.opt.list = true
  end
end, {})

-- Toggle clipboard.
vim.api.nvim_create_user_command("ToggleClipboard", function()
  if vim.o.clipboard == "unnamedplus" then
    vim.o.clipboard = "unnamed"
    vim.notify("set clipboard to unamed")
  else
    vim.o.clipboard = "unnamedplus"
    vim.notify("set clipboard to unamedplus (default)")
  end
end, {})

-- Toggle Diagnostic virtual text.
vim.g.diagnostic_virtual_text = true

vim.api.nvim_create_user_command("ToggleDiagnosticVirtualText", function()
  vim.g.diagnostic_virtual_text = not vim.g.diagnostic_virtual_text
  vim.diagnostic.config({ virtual_text = vim.g.diagnostic_virtual_text })
end, {})

-- Chat with Anhropic
vim.api.nvim_create_user_command('CodeCompanionChatAnthropic', function()
  vim.cmd('CodeCompanionChat anthropic')
end, {})

-- Toggle format on save
local function toggle_format_on_save()
  vim.g.format_on_save_enabled = not vim.g.format_on_save_enabled
  if vim.g.format_on_save_enabled then
    print('Format on Save enabled.')
  else
    print('Format on Save disabled.')
  end
end

vim.api.nvim_create_user_command('ToggleFormatOnSave', toggle_format_on_save, {})


-- Remove item in quckfix list
function Remove_qf_item()
  local curqfidx = vim.fn.line('.')
  local qfall = vim.fn.getqflist()

  -- Return if there are no items to remove
  if #qfall == 0 then return end

  -- Remove the item from the quickfix list
  table.remove(qfall, curqfidx)
  vim.fn.setqflist(qfall, 'r')

  -- Reopen quickfix window to refresh the list
  vim.cmd('copen')

  -- If not at the end of the list, stay at the same index, otherwise, go one up.
  local new_idx = curqfidx < #qfall and curqfidx or math.max(curqfidx - 1, 1)

  -- Set the cursor position directly in the quickfix window
  local winid = vim.fn.win_getid() -- Get the window ID of the quickfix window
  vim.api.nvim_win_set_cursor(winid, { new_idx, 0 })
end

vim.cmd("command! RemoveQFItem lua Remove_qf_item()")
vim.api.nvim_command("autocmd FileType qf nnoremap <buffer> dd :RemoveQFItem<cr>")
