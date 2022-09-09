local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

return packer.startup(function(use)
	use("wbthomason/packer.nvim") -- manage packer with packer
	use("nvim-lua/plenary.nvim") -- almost all plugins need this
	use("nvim-lua/popup.nvim") -- almost all plugins need this
	use("kyazdani42/nvim-web-devicons") -- almost all plugins need this
	use("christoomey/vim-tmux-navigator")
	use("simrat39/symbols-outline.nvim")
	use("nyngwang/NeoZoom.lua")
	use("lukas-reineke/indent-blankline.nvim") -- show identations
	use({
		"nvim-telescope/telescope.nvim",
		requires = {
			{ "nvim-telescope/telescope-live-grep-args.nvim" },
		},
	})

	use({
		"folke/which-key.nvim",
		commit = "9c190ea91939eba8c2d45660127e0403a5300b5a~1",
	})
	use("junegunn/vim-easy-align")
	use("windwp/nvim-autopairs")
	use("windwp/nvim-spectre") -- search and replace over all files
	use("romainl/vim-cool") -- disables search highlighting when you are done searching
	use("kyazdani42/nvim-tree.lua")
	use("hoob3rt/lualine.nvim")
	use("b3nj5m1n/kommentary")
	use("akinsho/toggleterm.nvim")
	use({
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup({})
		end,
	})
	use({
		"anuvyklack/pretty-fold.nvim",
		requires = "anuvyklack/nvim-keymap-amend",
		config = function()
			require("pretty-fold").setup({})
		end,
	})
	use({
		"anuvyklack/fold-preview.nvim",
		requires = "anuvyklack/keymap-amend.nvim",
		config = function()
			require("fold-preview").setup()
		end,
	})
	use({
		"folke/todo-comments.nvim",
		requires = "nvim-lua/plenary.nvim",
		config = function()
			require("todo-comments").setup({
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
				search = {
					-- regex that will be used to match keywords.
					-- don't replace the (KEYWORDS) placeholder
					pattern = [[\b(KEYWORDS):(]], -- ripgrep regex
					-- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
				},
			})
		end,
	})

	-- navigation
	use({
		"ggandor/leap.nvim",
		config = function()
			require("leap").set_default_keymaps()
		end,
	})
	use({
		"jinh0/eyeliner.nvim",
		config = function()
			require("eyeliner").setup({
				highlight_on_key = true,
			})
		end,
	})

	-- color schemes
	use("mcchrish/zenbones.nvim")
	use("rktjmp/lush.nvim")
	use({ "dracula/vim", as = "dracula" })
	use("folke/tokyonight.nvim")
	use("projekt0n/github-nvim-theme")
	use("mvpopuk/inspired-github.vim")
	use("buoto/gotests-vim") -- create go tests very quickly

	-- tests
	use("preservim/vimux")
	use({
		"vim-test/vim-test",
		config = function() -- the only way to make it work is to configure it here
			vim.cmd([[
          function! ToggleTermStrategy(cmd) abort
            call luaeval("require('toggleterm').exec(_A[1])", [a:cmd])
          endfunction
          let g:test#custom_strategies = {'toggleterm': function('ToggleTermStrategy')}
        ]])
			vim.g["test#strategy"] = "toggleterm"
		end,
	})

	-- tpope, the legend
	use({ "tpope/vim-repeat" }) -- repeat commands
	use({ "tpope/vim-vinegar" }) -- press - for local filebrowser
	use({ "tpope/vim-surround" }) -- cs)] turns surrounding ) into ]

	-- popup markdown preview
	use({ "npxbr/glow.nvim", run = ":GlowInstall" })

	-- git
	use("sindrets/diffview.nvim")
	use("TimUntersberger/neogit")
	use("samoshkin/vim-mergetool")
	use("lewis6991/gitsigns.nvim")
	use("whiteinge/diffconflicts")
	use("akinsho/git-conflict.nvim")

	-- buffers
	use("akinsho/nvim-bufferline.lua")
	use("kazhala/close-buffers.nvim")
	use("famiu/bufdelete.nvim")

	-- incremental syntax parsing
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	})
	use("JoosepAlviste/nvim-ts-context-commentstring")
	use("RRethy/nvim-treesitter-textsubjects")
	use("nvim-treesitter/nvim-treesitter-context")
	-- use("nvim-treesitter/nvim-treesitter-textobjects") -- currently disabled because it can make neovim unresponsive

	-- completion
	-- snippets
	use("L3MON4D3/LuaSnip") --snippet engine
	use("rafamadriz/friendly-snippets") -- a bunch of snippets to use
	-- cmp plugins
	use("hrsh7th/nvim-cmp") -- The completion plugin
	use("hrsh7th/cmp-buffer") -- buffer completions
	use("hrsh7th/cmp-path") -- path completions
	use("hrsh7th/cmp-cmdline") -- cmdline completions
	use("saadparwaiz1/cmp_luasnip") -- snippet completions
	use("hrsh7th/cmp-nvim-lsp") -- lsp cmp integartion
	use("hrsh7th/cmp-nvim-lsp-signature-help")

	-- LSP stuff
	use("onsails/lspkind-nvim")
	use("neovim/nvim-lspconfig")
	use("glepnir/lspsaga.nvim")
	use({ "williamboman/mason.nvim" })
	use({ "williamboman/mason-lspconfig.nvim" })
	use("jose-elias-alvarez/null-ls.nvim")
	use("j-hui/fidget.nvim") -- show lsp start status message

	-- DAP
	use("mfussenegger/nvim-dap")
	use("leoluz/nvim-dap-go")
	use({
		"rcarriga/nvim-dap-ui",
		requires = { "mfussenegger/nvim-dap" },
	})
	use("theHamsta/nvim-dap-virtual-text")

	use({
		"abecodes/tabout.nvim",
		config = function() -- the only way to make it work is to configure it here
			require("tabout").setup()
		end,
		wants = { "nvim-treesitter" }, -- or require if not used so far
		after = { "nvim-cmp" }, -- if a completion plugin is using tabs load it before
	})

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
