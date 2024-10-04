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

-- Command to format via conform
vim.api.nvim_create_user_command("Format", function(args)
  local range = nil
  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ["end"] = { args.line2, end_line:len() },
    }
  end
  require("conform").format({ async = true, lsp_fallback = true, range = range })
end, { range = true })


-- Disable autoformat
vim.api.nvim_create_user_command("FormatDisable", function(args)
  if args.bang then
    -- FormatDisable! will disable formatting just for this buffer
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = "Disable autoformat-on-save",
  bang = true,
})

-- Enable autoformat
vim.api.nvim_create_user_command("FormatEnable", function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = "Re-enable autoformat-on-save",
})


-- Chat with Anhropic
vim.api.nvim_create_user_command('CodeCompanionChatAnthropic', function()
  vim.cmd('CodeCompanionChat anthropic')
end, {})
