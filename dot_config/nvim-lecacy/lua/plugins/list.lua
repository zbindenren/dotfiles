local function load_config(package)
  return function()
    require('plugins.' .. package)
  end
end

local plugins = {
  -- UI
  {
    'zbindenren/le-grand-bleu.nvim',
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
    },
    config = load_config('ui.telescope'),
    cmd = 'Telescope',
  },
  {
    "debugloop/telescope-undo.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
      },
    },
    keys = {
      { -- lazy style key map
        "<leader>u",
        "<cmd>Telescope undo<cr>",
        desc = "undo history",
      },
    },
    opts = {
      -- don't use `defaults = { }` here, do this in the main telescope spec
      extensions = {
        undo = {
          -- telescope-undo.nvim config, see below
        },
        -- no other extensions here, they can have their own spec too
      },
    },
    config = function(_, opts)
      -- Calling telescope's setup from multiple specs does not hurt, it will happily merge the
      -- configs for us. We won't use data, as everything is in it's own namespace (telescope
      -- defaults, as well as each extension).
      require("telescope").setup(opts)
      require("telescope").load_extension("undo")
    end,
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
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>",  "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>",  "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>",  "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
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
        model = "claude-3-5-sonnet-20241022",
        timeout = 30000, -- Timeout in milliseconds
        temperature = 0,
        max_tokens = 8000,
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
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app; yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
      -- vim.g.mkdp_browser = "/Applications/Brave Browser.app"
    end,
    ft = { "markdown" },
  },
  {
    "mzlogin/vim-markdown-toc",
    cmd = { "GenTocGFM", "GenTocGitLab", "UpdateToc" },
    init = function()
      vim.g.vmt_auto_update_on_save = 0
    end,
    ft = { "markdown" },
  },
  {
    'RRethy/nvim-align',
    config = true,
    cmd = { 'Align' },
  },
  {
    'ruifm/gitlinker.nvim',
    config = function()
      require('gitlinker').setup({
        callbacks = {
          ["github.com"] = require("gitlinker.hosts").get_github_type_url,
          ["gitlab.com"] = require("gitlinker.hosts").get_gitlab_type_url,
        },
      })
    end,
  },
  {
    'LudoPinelli/comment-box.nvim',
    opts = {
      comment_style = "line",
      doc_width = 82,  -- width of the document
      line_width = 80, -- width of the lines
    },
    cmd = { 'CBllline' },
  },
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>ff",
        mode = { "n", "v" },
        "<cmd>Yazi<cr>",
        desc = "Open yazi at the current file",
      },
      {
        -- Open in the current working directory
        "<leader>e",
        "<cmd>Yazi cwd<cr>",
        desc = "Open the file manager in nvim's working directory",
      }
    },
    opts = {
      open_for_directories = true,
      keymaps = {
        show_help = "<f1>",
      },
    },
  }
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
