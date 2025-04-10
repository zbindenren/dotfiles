local M = {}

--- Modifies text at the current cursor position.
--- @param text string The text to insert or replace with
--- @param replace boolean When true, replaces the current line with the provided text;
---                        when false, inserts the text as a new line after the current position
local function modifyLineAtCursor(text, replace)
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))

  if replace then
    -- Replace the current line with the new text
    vim.api.nvim_buf_set_lines(0, row - 1, row, false, { text })
  else
    -- Insert a new line after the current cursor position
    vim.api.nvim_buf_set_lines(0, row, row, false, { text })
  end
end

--- Creates a centered header with a title surrounded by fill characters.
--- @param title string The text to be centered in the header
--- @param width number The total width of the header in characters
--- @return string The formatted header string with the title centered
local function createHeader(title, width)
  local fillChar = "━"

  -- Calculate how many fill characters we need on each side
  local titleLength = #title
  local remainingSpace = width - titleLength - 2 -- 2 for spaces around title
  local leftFill = math.floor(remainingSpace / 2)
  local rightFill = remainingSpace - leftFill

  -- Construct the header
  local header = string.rep(fillChar, leftFill) .. " " .. title .. " " .. string.rep(fillChar, rightFill)

  return header
end

--- Extracts the text content from a comment at the current cursor position.
--- Uses TreeSitter to identify comment nodes and strips comment markers.
---
--- @return string Comment text without markers (-, #, /) and whitespace, or empty string if:
---   - Current line is not a comment
---   - TreeSitter is not available
---   - Parser cannot be created for the current buffer
---   - Current buffer's filetype is not recognized
--- @return boolean Whether the current line is a comment
--- @return string The indentation of the current line
local function getComment()
  -- Get current buffer and cursor position
  local bufnr = vim.api.nvim_get_current_buf()
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1 -- Convert to 0-indexed
  local current_line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1] or ""
  local indentation = current_line:match("^%s*") or ""

  -- Check if TreeSitter is available for this buffer
  local has_ts, _ = pcall(require, "nvim-treesitter.locals")
  if not has_ts then
    return "", false, indentation
  end

  -- Get the parser for the current buffer
  local parser = vim.treesitter.get_parser(bufnr)
  if not parser then
    return "", false, indentation
  end

  -- Get the syntax tree
  local tree = parser:parse()[1]
  if not tree then
    return "", false, indentation
  end

  local root = tree:root()

  local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
  if not lang then
    return "", false, indentation
  end

  local query = vim.treesitter.query.parse(
    lang,
    [[
      (comment) @comment
    ]]
  )

  if not query then
    return "", false, indentation
  end

  -- Find comment nodes at the current line
  for id, node in query:iter_captures(root, bufnr, row, row + 1) do
    local name = query.captures[id]
    if name == "comment" then
      -- Get the text of the comment node
      local start_row, _, _, _ = node:range()
      if start_row == row then
        local comment_text = vim.treesitter.get_node_text(node, bufnr)

        comment_text = comment_text:gsub("━", "")
        comment_text = comment_text:gsub("%s+$", "") -- remove trailing whitespace
        comment_text = comment_text:gsub("^%s*[%-#/]+%s*", "") -- remove comment characters
        return comment_text, true, indentation
      end
    end
  end

  return "", current_line == "", indentation
end

--- Creates a formatted comment header at the current cursor position.
--- Prompts the user for a title, then creates a centered header surrounded by
--- decorative characters. If the cursor is on an existing comment line, that line
--- will be replaced; otherwise, a new line will be inserted.
---
--- The header is formatted according to the buffer's comment string and respects
--- the current indentation level. The total width is capped at 80 characters.
---
--- @usage Invoke via keybinding or command to create a section header in code
function M.create_comment_header()
  local input_text
  local default, isComment, indentation = getComment()
  Snacks.input.input({ prompt = "Comment Title", default = default }, function(value)
    local maxLength = 80
    local indentLength = #indentation
    local comment_prefix_lenth = #vim.bo.commentstring:format("")
    input_text = createHeader(value, maxLength - indentLength - comment_prefix_lenth)
    modifyLineAtCursor(indentation .. vim.bo.commentstring:format(input_text), isComment)
  end)
end

--- Finds and moves cursor to the next comment header in the buffer.
--- Searches downward from the current cursor position for a line containing a comment header.
--- If no header is found below the cursor, wraps around to search from the beginning of the file.
--- A comment header is identified by the pattern " ━━" which is part of the decorative header.
---
--- @usage Can be mapped to a keybinding for quick navigation between comment sections
function M.find_next_comment_header()
  local function find_next_comment(start_line)
    local pattern = " ━━"
    local last_line = vim.fn.line("$")

    for i = start_line, last_line do
      local content = vim.fn.getline(i)
      local start_pos = vim.fn.stridx(content, pattern)

      if start_pos ~= -1 then
        vim.api.nvim_win_set_cursor(0, { i, start_pos })
        return true
      end
    end
    return false
  end

  local current_line = vim.fn.line(".")
  local next_line = current_line + 1

  if not find_next_comment(next_line) then
    -- If no comment found from next line, try from the beginning
    if not find_next_comment(1) or vim.fn.line(".") == current_line then
      vim.notify("No more comments found", vim.log.levels.INFO)
    end
  end
end

--- Finds and moves cursor to the previous comment header in the buffer.
--- Searches upward from the current cursor position for a line containing a comment header.
--- If no header is found above the cursor, wraps around to search from the end of the file.
--- A comment header is identified by the pattern " ━━" which is part of the decorative header.
---
--- @usage Can be mapped to a keybinding for quick navigation between comment sections
function M.find_previous_comment_header()
  local function find_previous_comment(start_line)
    local pattern = " ━━"

    for i = start_line, 1, -1 do
      local content = vim.fn.getline(i)
      local start_pos = vim.fn.stridx(content, pattern)

      if start_pos ~= -1 then
        vim.api.nvim_win_set_cursor(0, { i, start_pos })
        return true
      end
    end
    return false
  end

  local current_line = vim.fn.line(".")
  local previous_line = current_line - 1

  if not find_previous_comment(previous_line) then
    -- If no comment found from previous line, try from the end
    local last_line = vim.fn.line("$")
    if not find_previous_comment(last_line) or vim.fn.line(".") == current_line then
      vim.notify("No more comments found", vim.log.levels.INFO)
    end
  end
end
return M
