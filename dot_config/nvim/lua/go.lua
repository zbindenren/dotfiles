local nvim_lsp = require("lspconfig")

nvim_lsp.gopls.setup({
	on_attach = require("utils").on_attach,
	codelens = { generate = true, gc_details = true },
	experimentalWorkspaceModule = true,
	semanticTokens = true,
	experimentalPostfixCompletions = true,
})

_G.whichkeyGo = function()
	local wk = require("which-key")
	wk.register({
		g = {
			name = "Go",
			a = { "<cmd>GoAlternate<cr>", "alternate impl and test" },
			d = { "<cmd>GoDoc<CR>", "go doc" },
			c = { "<cmd>GoCoverageToggle<cr>", "coverage toggle" },
			t = { "<cmd>GolangTestFocused <cr>", "test current function" },
		},
	}, { prefix = "<leader>" })
end

vim.cmd([[
  autocmd FileType go lua whichkeyGo()
]])
