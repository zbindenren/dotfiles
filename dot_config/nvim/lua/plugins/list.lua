local function load_config(package)
  return function()
    require('plugins.' .. package)
  end
end

local plugins = {
  -- UI
  -- {
  --   'mcchrish/zenbones.nvim',
  --   dependencies = {
  --     'rktjmp/lush.nvim',
  --   },
  --   config = load_config('ui.zenbones'),
  --   lazy = false,
  --   priority = 1000,
  -- },
  {
    dir = '/home/zbindenren/repos/github.com/zbindenren/le-grand-bleu',
    lazy = false,
    config = function()
      require('le-grand-bleu').setup({})
    end,
    priority = 1000,
    init = function()
      vim.cmd('colorscheme le-grand-bleu')
    end
  },
  {
    'nvim-pack/nvim-spectre',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = true,
    cmd = 'Spectre',
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = load_config('ui.lualine'),
    event = { 'BufReadPre', 'BufNewFile' },
  },
  -- {
  --   'nvimdev/dashboard-nvim',
  --   config = load_config('ui.dashboard'),
  --   dependencies = {
  --     'nvim-tree/nvim-web-devicons',
  --   },
  --   -- Only load when no arguments
  --   event = function()
  --     if vim.fn.argc() == 0 then
  --       return 'VimEnter'
  --     end
  --   end,
  --   cmd = 'Dashboard',
  -- },
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = load_config('ui.nvim-tree'),
    cmd = 'NvimTreeToggle',
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = 'Neotree',
    config = load_config('ui.neo-tree'),
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    }
  },
  {
    'folke/which-key.nvim',
    config = load_config('ui.which-key'),
    event = 'VeryLazy',
  },
  {
    'kazhala/close-buffers.nvim',
    config = true,
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
  -- {
  --   'Maan2003/lsp_lines.nvim',
  --   config = load_config('ui.lsp-lines'),
  --   event = 'LspAttach',
  -- },
  {
    'folke/flash.nvim',
    config = load_config('ui.flash'),
    keys = {
      {
        's',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').jump()
        end,
        desc = 'Flash',
      },
      {
        'S',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').treesitter()
        end,
        desc = 'Flash Treesitter',
      },
      {
        'r',
        mode = 'o',
        function()
          require('flash').remote()
        end,
        desc = 'Remote Flash',
      },
      {
        'R',
        mode = { 'o', 'x' },
        function()
          require('flash').treesitter_search()
        end,
        desc = 'Treesitter Search',
      },
      {
        '<c-s>',
        mode = { 'c' },
        function()
          require('flash').toggle()
        end,
        desc = 'Toggle Flash Search',
      },
    },
  },
  {
    'rcarriga/nvim-notify',
    config = load_config('ui.notify'),
    event = 'VeryLazy',
    cmd = 'Notifications',
  },

  -- Language
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    dependencies = {
      'neovim/nvim-lspconfig',
      'b0o/schemastore.nvim',
      'williamboman/mason-lspconfig.nvim',
      'j-hui/fidget.nvim',
      {
        'SmiteshP/nvim-navbuddy',
        dependencies = {
          "SmiteshP/nvim-navic",
          "MunifTanjim/nui.nvim"
        },
        opts = {
          lsp = {
            auto_attach = true,
          },
        }
      },
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
  {
    'nvim-neotest/neotest',
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-go",
    },
    config = load_config('lang.neotest'),
    cmd = 'Neotest',
  },
  {
    "olexsmir/gopher.nvim",
    ft = "go",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "mfussenegger/nvim-dap", -- (optional) only if you use `gopher.dap`
    },
    cmd = 'GoInstallDeps',
    build = function()
      vim.cmd.GoInstallDeps()
    end,
    opts = {},
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
    'sindrets/diffview.nvim',
    config = load_config('tools.diffview'),
    cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
    event = { 'BufReadPre', 'BufNewFile' },
  },
  {
    'akinsho/git-conflict.nvim',
    version = '*',
    config = load_config('tools.git-conflict'),
    cmd = 'GitConflictListQf',
    event = { 'BufReadPre', 'BufNewFile' },
  },
  {
    'numToStr/Navigator.nvim',
    config = load_config('tools.tmux-navigator'),
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
  {
    'stevearc/conform.nvim',
    config = load_config('tools.conform'),
    cmd = 'ConformInfo',
  },
  {
    'windwp/nvim-autopairs',
    config = load_config('tools.autopairs'),
    event = 'InsertEnter',
  },
  {
    'norcalli/nvim-colorizer.lua',
    config = true,
    cmd = { 'ColorizerAttachToBuffer', 'ColorizerDetachFromBuffer', 'ColorizerToggle' },
  },
  {
    'numToStr/Comment.nvim',
    config = load_config('tools.comment'),
    keys = {
      {
        'gcc',
        mode = { 'n' },
        function()
          require('Comment').toggle()
        end,
        desc = 'Comment',
      },
      {
        'gc',
        mode = { 'v' },
        function()
          require('Comment').toggle()
        end,
        desc = 'Comment',
      },
    },
  },
  {
    '2kabhishek/termim.nvim',
    cmd = { 'Fterm', 'FTerm', 'Sterm', 'STerm', 'Vterm', 'VTerm' },
  },
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "hrsh7th/nvim-cmp",              -- Optional: For using slash commands and variables in the chat buffer
      "nvim-telescope/telescope.nvim", -- Optional: For using slash commands
    },
    config = load_config('tools.codecompanion'),
    cmd = { 'CodeCompanion', 'CodeCompanionChat', 'CodeCompanionActions' },
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      search = {
        pattern = "\\b(KEYWORDS)[:(]", -- ripgrep regex
      },
    },
    cmd = { 'TodoQuickFix', 'TodoLocList', 'TodoTelescope' },
    event = { 'BufReadPre', 'BufNewFile' },
  },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    opts = {
      provider = "claude",
      claude = {
        endpoint = "https://api.anthropic.com",
        model = "claude-3-5-sonnet-20240620",
        timeout = 30000, -- Timeout in milliseconds
        temperature = 0,
        max_tokens = 8000,
        ["local"] = false,
      },
    },
    build = ":AvanteBuild", -- This is optional, recommended tho. Also note that this will block the startup for a bit since we are compiling bindings in Rust.
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua",      -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to setup it properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
  {
    'RRethy/nvim-align',
    config = true,
    cmd = { 'Align' },
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
  'jsonls',
  'yamlls',
  'lua_ls',
}

return {
  plugins = plugins,
  ts_parsers = ts_parsers,
  lsp_servers = lsp_servers,
}
