local status_ok, wk = pcall(require, "which-key")
if not status_ok then
	vim.notify("whichkey plugin not found!")
end

local opts = {
	mode = "n", -- NORMAL mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

local setup = {
	plugins = {
		presets = {
			operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
			motions = false, -- adds help for motions
			text_objects = false, -- help for text objects triggered after entering an operator
			windows = false, -- default bindings on <c-w>
			nav = false, -- misc bindings to work with windows
			z = true, -- bindings for folds, spelling and others prefixed with z
			g = true, -- bindings for prefixed with g
		},
	},
}

local mappings = {
	n = { "<cmd>lua require('utils').toggleNum()<cr>", "toggle number" },
	w = { "<cmd>w!<cr>", "Save" },
	c = {
		name = "code",
		d = { "<cmd>lua require('telescope.builtin').diagnostics()<cr>", "show diagnostics" },
		r = { "<cmd>lua require('telescope.builtin').lsp_references()<cr>", "show references" },
		s = { "<cmd>SymbolsOutline<cr>", "show tags" },
	},
	f = {
		name = "files",
		f = {
			"<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ previewer = false, hidden=true, file_ignore_patterns={'.git/', 'node_modules/'} }))<cr>",
			"list files",
		},
		g = { "<cmd>lua require('telescope.builtin').live_grep()<cr>", "grep in files" },
		s = { "<cmd>lua require('spectre').open_visual()<cr>", "search and replace in  files" },
	},
	b = {
		name = "buffers",
		b = {
			"<cmd>lua require'telescope.builtin'.buffers(require('telescope.themes').get_dropdown({ previewer = false, sort_lastused=true }))<cr>",
			"list buffers",
		},
		d = { "<cmd>:BWipeout this<cr>", "delete current buffer" },
		c = { "<cmd>:BWipeout other<cr>", "close all buffers except current" },
		C = { "<cmd>:BWipeout all<cr>", "close all buffers" },
		l = { "<cmd>BufferLineCycleNext<cr>", "go to next buffer" },
		h = { "<cmd>BufferLineCyclePrev<cr>", "go to previous buffer" },
		s = { "<cmd>lua require('spectre').open_file_search()<cr>", "search and replace in  files" },
	},
	v = {
		name = "version control",
		f = { "<cmd>lua require('telescope.builtin').git_status()<cr>", "git status (changed files)" },
		c = { "<cmd>lua require('telescope.builtin').git_commits()<cr>", "git commits" },
		l = { "<cmd>lua _LAZYGIT_TOGGLE()<cr>", "open lazygit" },
		b = { "<cmd>Telescope git_branches<cr>", "show branches" },
		g = { "<cmd>Telescope git_status<cr>", "current changes" },
		B = { "<cmd>Gitsigns toggle_current_line_blame<cr>", "blame current line" },
		o = { "<cmd>Neogit<cr>", "open neogit" },
		d = { "<cmd>DiffviewOpen<cr>", "open diffsplit" },
		C = { "<cmd>DiffviewClose<cr>", "close diffsplit" },
		P = { "<cmd>Gitsigns preview_hunk<cr>", "preview current hunk" },
		R = { "<cmd>Gitsigns reset_hunk<cr>", "reset current hunk" },
		p = { "<cmd>Gitsigns prev_hunk<cr>", "previous hunk" },
		n = { "<cmd>Gitsigns next_hunk<cr>", "next hunk" },
		m = { "<plug>(MergetoolToggle)", "toggle mergetool" },
	},
	m = {
		name = "mergetool",
		t = { "<plug>(MergetoolToggle)", "toggle mergetool" },
		s = {
			"<leader>mb :call mergetool#toggle_layout('mr')<cr>",
			"toggle mergetool (merged | remote )",
			noremap = true,
			silent = true,
		},
		b = {
			"<leader>mb :call mergetool#toggle_layout('mr,b')<cr>",
			"toggle mergetool (merged | remote _ base )",
			noremap = true,
			silent = true,
		},
		l = {
			"<leader>mb :call mergetool#toggle_layout('LBR')<cr>",
			"toggle mergetool (local | base | remote)",
			noremap = true,
			silent = true,
		},
	},
	t = {
		name = "tests",
		f = { "<cmd>TestNearest -count=1 -v<cr>", "test nearest function" },
		a = { "<cmd>lua _GO_LINT_N_TEST_TOGGLE()<cr>", "go lint and test" },
		i = { "<cmd>TestNearest -count=1 -tags integration -v<cr>", "integration test nearest function" },
		t = { "<cmd>lua _GO_TEST_TOGGLE()<cr>", "go test in toggleterm" },
		l = { "<cmd>lua _GO_LINT_TOGGLE()<cr>", "golangci-lint in toggleterm" },
	},
}

wk.setup(setup)
wk.register(mappings, opts)
