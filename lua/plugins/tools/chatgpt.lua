local status_ok, chatgpt = pcall(require, "chatgpt")
if not status_ok then
  vim.notify("chatgpt plugin not found!")
  return
end

chatgpt.setup({
  api_key_cmd = "cat /home/rz/.chatgpt.nvim",
  chat = {
    keymaps = {
      new_session = "<C-e>",
    }
  }
})
