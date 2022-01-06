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

return require("packer").startup(function(use)
	use("wbthomason/packer.nvim")

	use("christoomey/vim-tmux-navigator")

	use("ojroques/vim-oscyank")

	use("simrat39/symbols-outline.nvim")

	use({ "dracula/vim", as = "dracula" })
	use({
		"rose-pine/neovim",
		as = "rose-pine",
	})
	use({
		"catppuccin/nvim",
		as = "catppuccin",
	})
	use({ "folke/tokyonight.nvim" })
	use({ "shaunsingh/nord.nvim" })
	use({ "nyngwang/NeoZoom.lua" })

	use({
		"nvim-telescope/telescope.nvim",
		requires = { { "nvim-lua/popup.nvim" }, { "nvim-lua/plenary.nvim" } },
	})

	use({ "folke/which-key.nvim" })

	-- use({ "fatih/vim-go" })

	use({ "ggandor/lightspeed.nvim" })

	-- tpope, the legend
	use({ "tpope/vim-commentary" })
	use({ "tpope/vim-repeat" }) -- repeat commands
	use({ "tpope/vim-vinegar" }) -- press - for local filebrowser
	use({ "tpope/vim-surround" }) -- cs)] turns surrounding ) into ]

	use({ "vim-test/vim-test", requires = { { "preservim/vimux" } } })

	use({ "junegunn/vim-easy-align" })

	-- popup markdown preview
	use({ "npxbr/glow.nvim", run = ":GlowInstall" })

	require("plenary") -- otherwise neovim crashes on startup opening a file: https://github.com/TimUntersberger/neogit/issues/206
	use({
		"TimUntersberger/neogit",
		requires = { "sindrets/diffview.nvim", "nvim-lua/plenary.nvim" },
		config = function()
			require("neogit").setup({
				disable_commit_confirmation = true,
				integrations = {
					diffview = true,
				},
			})
		end,
	})

	use({
		"lewis6991/gitsigns.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("gitsigns").setup()
		end,
	})

	use({ "samoshkin/vim-mergetool" })

	-- buffers
	use({
		"akinsho/nvim-bufferline.lua",
		requires = "kyazdani42/nvim-web-devicons",
		config = function()
			require("bufferline").setup()
		end,
	})
	use({ "kazhala/close-buffers.nvim" })

	use({ "famiu/bufdelete.nvim" })

	-- incremental syntax parsing, the mother of modernity
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	})

	-- file tree instead of nerdtree (needs a patched font from: https://www.nerdfonts.com/)
	use({
		"kyazdani42/nvim-tree.lua",
		requires = "kyazdani42/nvim-web-devicons",
		config = function()
			require("nvim-tree").setup({
				auto_close = true,
				view = {
					auto_resize = true,
				},
			})
		end,
	})

	-- show indents
	use({ "lukas-reineke/indent-blankline.nvim" })

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
	use("hrsh7th/cmp-nvim-lsp")

	use({ "windwp/nvim-autopairs" })

	-- show code actions as lightbulb
	use({ "kosayoda/nvim-lightbulb" })

	use({
		"windwp/nvim-spectre",
		requires = { { "nvim-lua/plenary.nvim" }, { "nvim-lua/popup.nvim" } },
	})

	-- LSP stuff
	use({
		"onsails/lspkind-nvim",
		"neovim/nvim-lspconfig",
		"glepnir/lspsaga.nvim",
		"ray-x/lsp_signature.nvim",
		"williamboman/nvim-lsp-installer",
	})

	use({
		"jose-elias-alvarez/null-ls.nvim",
		config = function()
			require("null-ls").setup({
				sources = {
					require("null-ls").builtins.formatting.stylua,
					require("null-ls").builtins.formatting.goimports,
					require("null-ls").builtins.diagnostics.eslint,
					require("null-ls").builtins.completion.spell,
					require("null-ls").builtins.diagnostics.golangci_lint,
					require("null-ls").builtins.formatting.prettier,
					require("null-ls").builtins.formatting.terraform_fmt,
					require("null-ls").builtins.formatting.trim_whitespace.with({
						disabled_filetypes = { "go" },
					}),
					require("null-ls").builtins.formatting.trim_newlines.with({
						disabled_filetypes = { "go" },
					}),
				},
				on_attach = function(client)
					if client.resolved_capabilities.document_formatting then
						vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()")
					end
				end,
			})
		end,
		requires = { "nvim-lua/plenary.nvim" },
	})

	use({
		"hoob3rt/lualine.nvim",
		config = function()
			require("lualine").setup({
				options = {
					theme = "tokyonight",
				},
			})
		end,
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
	})

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
