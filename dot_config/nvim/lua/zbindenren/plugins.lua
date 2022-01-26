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
	use("ojroques/vim-oscyank")
	use("simrat39/symbols-outline.nvim")
	use({ "dracula/vim", as = "dracula" })
	use("folke/tokyonight.nvim")
	use("nyngwang/NeoZoom.lua")
	use("lukas-reineke/indent-blankline.nvim") -- show identations
	use("nvim-telescope/telescope.nvim")
	use("folke/which-key.nvim")
	use("ggandor/lightspeed.nvim")
	use("junegunn/vim-easy-align")
	use("windwp/nvim-autopairs")
	use("windwp/nvim-spectre") -- search and replace over all files
	use("kyazdani42/nvim-tree.lua")
	use("hoob3rt/lualine.nvim")
	use("numToStr/Comment.nvim")
	use("SmiteshP/nvim-gps") -- show context in statusline

	-- tests
	use("preservim/vimux")
	use("vim-test/vim-test")

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

	-- LSP stuff
	use({ "onsails/lspkind-nvim" })
	use({ "neovim/nvim-lspconfig" })
	use({ "glepnir/lspsaga.nvim" })
	use({ "ray-x/lsp_signature.nvim" })
	use({ "williamboman/nvim-lsp-installer" })
	use("jose-elias-alvarez/null-ls.nvim")

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
