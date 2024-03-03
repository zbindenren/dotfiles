local function load_config(package)
  return function()
    require('plugins.' .. package)
  end
end

local plugins = {
  -- UI
  {
    'mcchrish/zenbones.nvim',
    dependencies = {
      'rktjmp/lush.nvim',
    },
    config = load_config('ui.zenbones'),
    lazy = false,
    priority = 1000,
  },
  {
    'nvimdev/dashboard-nvim',
    config = load_config('ui.dashboard'),
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    -- Only load when no arguments
    event = function()
      if vim.fn.argc() == 0 then
        return 'VimEnter'
      end
    end,
    cmd = 'Dashboard',
  },
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = load_config('ui.nvim-tree'),
    cmd = 'NvimTreeToggle',
  },
  {
    'folke/which-key.nvim',
    config = load_config('ui.which-key'),
    event = 'VeryLazy',
  },
  {
    'nvim-telescope/telescope.nvim',
    --    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
      },
      'nvim-telescope/telescope-symbols.nvim',
      'molecule-man/telescope-menufacture',
      'debugloop/telescope-undo.nvim',
      'ThePrimeagen/harpoon',
    },
    config = load_config('ui.telescope'),
    cmd = 'Telescope',
  },
  {
    'gelguy/wilder.nvim',
    build = function()
      vim.cmd([[silent UpdateRemotePlugins]])
    end,
    config = load_config('ui.wilder'),
    keys = { ':', '/', '?' },
  },
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-nvim-lua',
      'saadparwaiz1/cmp_luasnip',
    },
    config = load_config('ui.cmp'),
    event = 'InsertEnter',
  },


  -- Language
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    dependencies = {
      'neovim/nvim-lspconfig',
      'williamboman/mason-lspconfig.nvim',
      'j-hui/fidget.nvim',
    },
    config = load_config('lang.lsp-zero'),
    event = { 'BufReadPre', 'BufNewFile' },
  },
  {
    'williamboman/mason.nvim',
    config = load_config('lang.mason'),
    cmd = 'Mason',
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'RRethy/nvim-treesitter-endwise',
      'RRethy/nvim-treesitter-textsubjects',
      'windwp/nvim-ts-autotag',
    },
    config = load_config('lang.treesitter'),
    event = { 'BufReadPre', 'BufNewFile' },
  },
  {
    'L3MON4D3/LuaSnip',
    version = 'v2.*',
    dependencies = { 'rafamadriz/friendly-snippets' },
    build = 'make install_jsregexp',
    event = 'InsertEnter',
  },

  -- Tools
  {
    'lewis6991/gitsigns.nvim',
    config = load_config('tools.gitsigns'),
    cmd = 'Gitsigns',
    event = { 'BufReadPre', 'BufNewFile' },
  },
  {
    'TimUntersberger/neogit',
    config = load_config('tools.neogit'),
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim",
    },
    cmd = 'Neogit',
    event = { 'BufReadPre', 'BufNewFile' },
  },
  {
    'aserowy/tmux.nvim',
    config = load_config('tools.tmux'),
    event = function()
      if vim.fn.exists('$TMUX') == 1 then
        return 'VeryLazy'
      end
    end,
  },
  {
    'mfussenegger/nvim-lint',
    config = load_config('tools.nvim-lint'),
    event = { 'BufReadPre', 'BufNewFile' },
  },
}

local ts_parsers = {
  'bash',
  'css',
  'gitcommit',
  'go',
  'html',
  'javascript',
  'json',
  'lua',
  'markdown',
  'markdown_inline',
  'python',
  'ruby',
  'rust',
  'typescript',
  'vim',
  'vimdoc',
  'yaml',
}

local lsp_servers = {
  'bashls',
  'gopls',
}

return {
  plugins = plugins,
  ts_parsers = ts_parsers,
  lsp_servers = lsp_servers,
}
