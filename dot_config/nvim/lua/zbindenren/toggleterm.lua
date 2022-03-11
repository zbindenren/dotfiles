local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
	vim.notify("toggleterm plugin not found!")
end

toggleterm.setup({
	size = 20,
	open_mapping = [[<c-\>]],
	hide_numbers = true,
	shade_filetypes = {},
	shade_terminals = true,
	shading_factor = 2,
	start_in_insert = true,
	insert_mappings = true,
	persist_size = true,
	direction = "float",
	close_on_exit = true,
	shell = vim.o.shell,
	float_opts = {
		border = "curved",
		winblend = 0,
		highlights = {
			border = "Normal",
			background = "Normal",
		},
	},
})

function _G.set_terminal_keymaps()
	local opts = { noremap = true }
	vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], opts)
	vim.api.nvim_buf_set_keymap(0, "t", "jk", [[<C-\><C-n>]], opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
end

vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({
	cmd = "lazygit",
	hidden = true,
	on_open = function(term)
		vim.cmd("startinsert!")
		if vim.fn.mapcheck("<esc>", "t") ~= "" then
			vim.api.nvim_buf_del_keymap(term.bufnr, "t", "<esc>") -- force <esc> to behave like a normal <esc>
		end
	end,
})

function _LAZYGIT_TOGGLE()
	lazygit:toggle()
end

function _LAB_OPEN_TOGGLE()
	toggleterm.exec("Lab open")
end

function _LAB_OPEN_PIPELINE_TOGGLE()
	toggleterm.exec("clear && Lab open -p")
end

function _GO_TEST_TOGGLE()
	toggleterm.exec("go test ./...")
end

function _GO_LINT_TOGGLE()
	toggleterm.exec("golangci-lint run")
end

function _GO_LINT_N_TEST_TOGGLE()
	toggleterm.exec("golangci-lint run && go test ./...")
end
