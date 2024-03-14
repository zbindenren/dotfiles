local status_ok, lualine = pcall(require, 'lualine')
if not status_ok then
  return
end

local icons = require('lib.icons')

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
  end,
  buffer_is_file = function()
    return vim.bo.buftype == ''
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand('%:p:h')
    local gitdir = vim.fn.finddir('.git', filepath .. ';')
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}
local searchcount = { 'searchcount' }
local selectioncount = { 'selectioncount' }
local progress = { 'progress' }
local filetype = { 'filetype' }
local filesize = { 'filesize', cond = conditions.buffer_not_empty }
local fileformat = { 'fileformat', icons_enabled = true }

local filename = {
  'filename',
  cond = conditions.buffer_not_empty and conditions.buffer_is_file,
}

local buffers = {
  'buffers',
  filetype_names = {
    TelescopePrompt = icons.ui.Telescope .. 'Telescope',
    dashboard = icons.ui.Dashboard .. 'Dashboard',
    lazy = icons.ui.Sleep .. 'Lazy',
    mason = icons.ui.Package .. 'Mason',
    NvimTree = icons.documents.OpenFolder .. 'Files',
    spectre_panel = icons.ui.Search .. 'Spectre',
  },
  use_mode_colors = true,
}

local branch = {
  'branch',
  icon = icons.git.Branch,
  fmt = function(str)
    return str:sub(1, 32)
  end,
}

local diff_icons = {
  'diff',
  symbols = { added = icons.git.AddAlt, modified = icons.git.DiffAlt, removed = icons.git.RemoveAlt },
  cond = conditions.hide_in_width,
}

local diagnostics = {
  'diagnostics',
  sources = { 'nvim_lsp', 'nvim_diagnostic', 'nvim_workspace_diagnostic' },
  symbols = {
    error = icons.diagnostics.Error,
    warn = icons.diagnostics.Warning,
    info = icons.diagnostics.Information,
    hint = icons.diagnostics.Hint,
  },
}

local lsp = {
  function()
    local msg = 'No LSP'
    local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
    local clients = vim.lsp.get_active_clients()
    if next(clients) == nil then
      return msg
    end
    for _, client in ipairs(clients) do
      local filetypes = client.config.filetypes
      if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
        return client.name
      end
    end
    return msg
  end,
  icon = icons.ui.Gear,
}

local encoding = {
  'o:encoding',
  fmt = string.upper,
  cond = conditions.hide_in_width,
}

local separator = {
  function()
    return icons.ui.Separator
  end,
  padding = { left = 0, right = 0 },
}

local function mode(icon)
  icon = icon or icons.ui.NeoVim
  return {
    function()
      return icon
    end,
    padding = { left = 1, right = 0 },
  }
end

local config = {
  options = {
    component_separators = '',
    -- section_separators = '',
    theme = 'onedark',
    disabled_filetypes = {
      statusline = { 'dashboard' },
      winbar = { 'dashboard' },
    },
  },
  -- extensions = { 'quickfix', 'man', 'mason', 'lazy', 'toggleterm', 'nvim-tree' },
  tabline = {
    lualine_a = {},
    lualine_b = { mode(), buffers },
    lualine_c = {
      "navic",
      color_correction = nil, -- Can be nil, "static" or "dynamic". This option is useful only when you have highlights enabled.
      navic_opts = nil        -- lua table with same format as setup's option. All options except "lsp" options take effect when set here.
    },
    lualine_x = { diff_icons, branch },
    lualine_y = { searchcount, selectioncount },
    lualine_z = {},
  },
  sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { separator, mode(icons.ui.Heart), 'location', progress, filename },
    lualine_x = { diagnostics, lsp, filetype, filesize, fileformat, encoding, separator },
    lualine_y = {},
    lualine_z = {},
  },
}

lualine.setup(config)
