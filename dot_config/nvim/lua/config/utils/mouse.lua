local M = {}

function M.toggle_mouse()
  local current_mouse = vim.api.nvim_get_option_value("mouse", {})
  if current_mouse == "a" then
    vim.opt.mouse = ""
    vim.notify("Mouse disabled", vim.log.levels.INFO)
  else
    vim.opt.mouse = "a"
    vim.notify("Mouse enabled", vim.log.levels.INFO)
  end
end

return M
