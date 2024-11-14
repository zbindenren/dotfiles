local function augroup(name)
  return vim.api.nvim_create_augroup('zbindenren_' .. name, { clear = true })
end

-- Jump to last known position
vim.api.nvim_create_autocmd('BufRead', {
  callback = function(opts)
    vim.api.nvim_create_autocmd('BufWinEnter', {
      once = true,
      buffer = opts.buf,
      callback = function()
        local ft = vim.bo[opts.buf].filetype
        local last_known_line = vim.api.nvim_buf_get_mark(opts.buf, '"')[1]
        if
            not (ft:match('commit') and ft:match('rebase'))
            and last_known_line > 1
            and last_known_line <= vim.api.nvim_buf_line_count(opts.buf)
        then
          vim.api.nvim_feedkeys([[g`"]], 'nx', false)
        end
      end,
    })
  end,
})

-- ━━ Strip trailing spaces before write ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  group = augroup('strip_space'),
  pattern = { '*' },
  callback = function()
    if vim.g.format_on_save_enabled then
      vim.cmd([[ %s/\s\+$//e ]])
    end
  end,
})

-- ━━ Check if we need to reload the file when it changed ━━━━━━━━━━━━━━━━━━━━━━
vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  group = augroup('checktime'),
  command = 'checktime',
})

-- ━━ Highlight on yank ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
vim.api.nvim_create_autocmd('TextYankPost', {
  group = augroup('highlight_yank'),
  callback = function()
    vim.highlight.on_yank({ timeout = 500 })
  end,
})

-- ━━ Resize splits if window got resized ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
vim.api.nvim_create_autocmd({ 'VimResized' }, {
  group = augroup('resize_splits'),
  callback = function()
    vim.cmd('tabdo wincmd =')
  end,
})

-- ━━ Go to last loc when opening a buffer ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
vim.api.nvim_create_autocmd('BufReadPost', {
  group = augroup('last_loc'),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- ━━ Close some filetypes with <q> ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
vim.api.nvim_create_autocmd('FileType', {
  group = augroup('close_with_q'),
  pattern = {
    'PlenaryTestPopup',
    'help',
    'Jaq',
    'lir',
    'DressingSelect',
    'lspinfo',
    'man',
    'notify',
    'qf',
    'spectre_panel',
    'startuptime',
    'tsplayground',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
  end,
})

-- ━━ Wrap and check for spell in text filetypes ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
vim.api.nvim_create_autocmd('FileType', {
  group = augroup('wrap_spell'),
  pattern = { 'gitcommit', 'markdown' },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})


-- ━━ LSP format on save. ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local format_on_save_group = vim.api.nvim_create_augroup('FormatOnSave', { clear = true })

vim.g.format_on_save_enabled = true
vim.api.nvim_create_autocmd("BufWritePre", {
  group = format_on_save_group,
  pattern = { "*.go", "*.lua" },
  callback = function()
    if vim.g.format_on_save_enabled then
      vim.lsp.buf.format({
        timeout_ms = 3000
      })
    end
  end,
})


-- ━━ Go organize imports on save. ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.go" },
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { "source.organizeImports" } }

    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
    for _, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local client = vim.lsp.get_client_by_id(vim.lsp.get_clients()[1].id)
          if client then
            local enc = client.offset_encoding or "utf-16"
            vim.lsp.util.apply_workspace_edit(r.edit, enc)
          end
        elseif r.command then
          vim.lsp.buf.execute_command(r.command)
        end
      end
    end
  end
})

-- ━━ Lint when writing file. ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    require("lint").try_lint()
  end,
})

-- ━━ Additional filetypes ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
vim.filetype.add({
  extension = {
    templ = "templ",
  },
})

-- ━━ Highlight symbol under cursor ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
vim.opt.updatetime = 1500

local function highlight_symbol(event)
  local id = vim.tbl_get(event, 'data', 'client_id')
  local client = id and vim.lsp.get_client_by_id(id)
  if client == nil or not client.supports_method('textDocument/documentHighlight') then
    return
  end

  local group = vim.api.nvim_create_augroup('highlight_symbol', { clear = false })

  vim.api.nvim_clear_autocmds({ buffer = event.buf, group = group })

  vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
    group = group,
    buffer = event.buf,
    callback = vim.lsp.buf.document_highlight,
  })

  vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
    group = group,
    buffer = event.buf,
    callback = vim.lsp.buf.clear_references,
  })
end

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'Setup highlight symbol',
  callback = highlight_symbol,
})
