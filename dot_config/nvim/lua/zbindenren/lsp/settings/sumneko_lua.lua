return {
	settings = {
		Lua = {
			format = {
				enable = false, -- let null-ls handle the formatting
			},
			filetypes = { "lua" },
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
		},
	},
}
