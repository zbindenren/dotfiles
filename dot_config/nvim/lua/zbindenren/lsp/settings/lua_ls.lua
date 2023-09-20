return {
	settings = {
		Lua = {
			format = {
				enable = false, -- let formatter handle the formatting
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
