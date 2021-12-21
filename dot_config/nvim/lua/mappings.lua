-- nvimtree
vim.api.nvim_set_keymap("n", "<leader><leader>", ":NvimTreeToggle<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader><leader>f", ":NvimTreeFindFile<cr>", { noremap = true })

-- OSCYank
vim.api.nvim_set_keymap("v", "<leader>y", ":OSCYank<cr>", { noremap = true })

-- Shift + J/K moves selected lines down/up in visual mode
vim.api.nvim_set_keymap("v", "J", ":m '>+1<CR>gv=gv", { noremap = true })
vim.api.nvim_set_keymap("v", "K", ":m '<-2<CR>gv=gv", { noremap = true })

-- avoid clashing with leader as space
vim.api.nvim_set_keymap("n", "<space>", "<nop>", { noremap = true, silent = true })

-- code completion
vim.api.nvim_set_keymap("i", "<cr>", "compe#confirm('<cr>')", { expr = true })
vim.api.nvim_set_keymap("i", "<c-j>", 'pumvisible() ? "\\<c-n>" : "\\<c-j>"', { noremap = true, expr = true })
vim.api.nvim_set_keymap("i", "<c-k>", 'pumvisible() ? "\\<c-p>" : "\\<c-j>"', { noremap = true, expr = true })
vim.api.nvim_set_keymap("i", "<c-space>", "compe#complete()", { noremap = true, expr = true })

-- jj as <esc>
vim.api.nvim_set_keymap("i", "jj", "<esc>", { noremap = true })

-- resize windows
vim.api.nvim_set_keymap("n", "<a-up>", "<cmd>resize -5<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<a-down>", "<cmd>resize +5<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<a-right>", "<cmd>vertical resize -5<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<a-left>", "<cmd>vertical resize +5<cr>", { noremap = true })

-- mergetool
vim.api.nvim_set_keymap("n", "<c-left>", '&diff? "<plug>(MergetoolDiffExchangeLeft)" : "\\<c-left>"', { expr = true })
vim.api.nvim_set_keymap(
	"n",
	"<c-right>",
	'&diff? "<plug>(MergetoolDiffExchangeRight)" : "\\<c-right>"',
	{ expr = true }
)
vim.api.nvim_set_keymap("n", "<c-up>", '&diff? "<plug>(MergetoolDiffExchangeUp)" : "\\<c-up>"', { expr = true })
vim.api.nvim_set_keymap("n", "<c-down>", '&diff? "<plug>(MergetoolDiffExchangeDown)" : "\\<c-down>"', { expr = true })
vim.api.nvim_set_keymap("n", "<up>", '&diff ? "[c" : "<up>"', { expr = true })
vim.api.nvim_set_keymap("n", "<down>", '&diff ? "]c" : "<down>"', { expr = true })

-- EasyAlign
vim.api.nvim_set_keymap("n", "ga", "<plug>(EasyAlign)", {})
vim.api.nvim_set_keymap("x", "ga", "<plug>(EasyAlign)", {})

-- discoverable mappings
local wk = require("which-key")

wk.register({
	n = { "<cmd>lua require('utils').toggleNum()<cr>", "toggle number" },
	c = {
		name = "code",
		d = { "<cmd>lua require('telescope.builtin').lsp_workspace_diagnostics()<cr>", "show diagnostics" },
		r = { "<cmd>lua require('telescope.builtin').lsp_references()<cr>", "show references" },
		s = { "<cmd>SymbolsOutline<cr>", "show tags" },
	},
	f = {
		name = "files",
		f = {
			"<cmd>lua require('telescope.builtin').find_files({hidden=true, file_ignore_patterns={'.git/', 'node_modules/'}})<cr>",
			"list files",
		},
		g = { "<cmd>lua require('telescope.builtin').live_grep()<cr>", "grep in files" },
		s = { "<cmd>lua require('spectre').open_visual()<cr>", "search and replace in  files" },
	},
	b = {
		name = "buffers",
		b = { "<cmd>lua require('telescope.builtin').buffers({sort_lastused=true})<cr>", "list buffers" },
		d = { "<cmd>:BWipeout this<cr>", "delete current buffer" },
		c = { "<cmd>:BWipeout other<cr>", "close all buffers except current" },
		C = { "<cmd>:BWipeout all<cr>", "close all buffers" },
		l = { "<cmd>BufferLineCycleNext<cr>", "go to next buffer" },
		h = { "<cmd>BufferLineCyclePrev<cr>", "go to previous buffer" },
		s = { "<cmd>lua require('spectre').open_file_search()<cr>", "search and replace in  files" },
	},
	v = {
		name = "version control",
		f = { "<cmd>lua require('telescope.builtin').git_commits()<cr>", "find commits" },
		b = { "<cmd>Telescope git_branches<cr>", "show branches" },
		g = { "<cmd>Telescope git_status<cr>", "current changes" },
		B = { "<cmd>Gitsigns toggle_current_line_blame<cr>", "blame current line" },
		o = { "<cmd>Neogit<cr>", "open neogit" },
		d = { "<cmd>DiffviewOpen<cr>", "open diffsplit" },
		c = { "<cmd>DiffviewClose<cr>", "close diffsplit" },
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
		a = { "<cmd>TestFile -v<cr>", "test all" },
		i = { "<cmd>TestNearest -count=1 -tags integration -v<cr>", "integration test nearest function" },
	},
}, { prefix = "<leader>" })
