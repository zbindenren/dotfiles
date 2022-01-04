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
		config = function()
			local ts = require("nvim-treesitter.configs")
			ts.setup({ ensure_installed = "maintained", highlight = { enable = true } })
		end,
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

	-- spell checking
	use({
		"lewis6991/spellsitter.nvim",
		config = function()
			require("spellsitter").setup()
		end,
	})

	-- snippets
	use({ "hrsh7th/vim-vsnip" })
	use({ "hrsh7th/vim-vsnip-integ" })
	use({ "golang/vscode-go" })

	-- autocompletion
	use({
		"hrsh7th/nvim-compe",
		config = function()
			require("compe").setup({
				enabled = true,
				autocomplete = true,
				debug = false,
				min_length = 1,
				preselect = "enable",
				throttle_time = 80,
				source_timeout = 200,
				incomplete_delay = 400,
				max_abbr_width = 100,
				max_kind_width = 100,
				max_menu_width = 100,
				documentation = true,

				source = { path = true, buffer = false, calc = true, nvim_lsp = true, nvim_lua = true, vsnip = true },
			})
		end,
	})

	use({
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup()
			require("nvim-autopairs.completion.compe").setup({
				map_cr = true, --  map <CR> on insert mode
				map_complete = true, -- it will auto insert `(` after select function or method item
			})
		end,
	})

	-- show code actions as lightbulb
	use({ "kosayoda/nvim-lightbulb" })

	use({
		"windwp/nvim-spectre",
		requires = { { "nvim-lua/plenary.nvim" }, { "nvim-lua/popup.nvim" } },
	})

	-- LSP goodies
	use({
		"onsails/lspkind-nvim",
		"neovim/nvim-lspconfig",
		"glepnir/lspsaga.nvim",
		"ray-x/lsp_signature.nvim",
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
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
	})

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
