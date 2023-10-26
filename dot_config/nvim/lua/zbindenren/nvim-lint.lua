local status_ok, conform = pcall(require, "lint")

if not status_ok then
	vim.notify("nvim-lint plugin not found!")
	return
end

conform.linters_by_ft = {
	go = { "golangcilint" },
	yaml = { "yamllint" },
	markdown = { "markdownlint" },
}
