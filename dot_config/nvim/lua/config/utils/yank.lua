local M = {}

--- Returns all diagnostics for the given line range in the current buffer.
--- @param start_line number 1-indexed start line
--- @param end_line number 1-indexed end line
--- @return string[] diagnostic messages
local function get_diagnostics(start_line, end_line)
  local bufnr = vim.api.nvim_get_current_buf()
  local messages = {}

  for lnum = start_line, end_line do
    local diags = vim.diagnostic.get(bufnr, { lnum = lnum - 1 })
    for _, d in ipairs(diags) do
      table.insert(messages, d.message)
    end
  end

  return messages
end

--- Copies a file reference with line number(s) and diagnostics to the system clipboard.
--- In normal mode, copies `@path#L<line>`. In visual mode, copies `@path#L<start>-<end>`.
--- Appends any LSP diagnostics on the selected line(s) as separate lines.
--- The path is relative to the current working directory (project root).
function M.yank_file_reference()
  local filepath = vim.fn.fnamemodify(vim.fn.expand("%"), ":.")
  local mode = vim.fn.mode()
  local ref
  local start_line, end_line

  if mode == "v" or mode == "V" or mode == "\22" then
    start_line = vim.fn.line("v")
    end_line = vim.fn.line(".")
    if start_line > end_line then
      start_line, end_line = end_line, start_line
    end
    if start_line == end_line then
      ref = string.format("@%s#L%d", filepath, start_line)
    else
      ref = string.format("@%s#L%d-%d", filepath, start_line, end_line)
    end
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
  else
    start_line = vim.fn.line(".")
    end_line = start_line
    ref = string.format("@%s#L%d", filepath, start_line)
  end

  local diags = get_diagnostics(start_line, end_line)
  if #diags > 0 then
    ref = ref .. "\n" .. table.concat(diags, "\n")
  end

  vim.fn.setreg("+", ref)
  vim.notify("Copied: " .. ref, vim.log.levels.INFO)
end

return M
