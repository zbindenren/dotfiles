local status_ok, prompts = pcall(require, "plugins.prompts.prompts")
if not status_ok then
  vim.notify("prompts not found!")
  return
end

local constants = {
  LLM_ROLE = "llm",
  USER_ROLE = "user",
  SYSTEM_ROLE = "system",
}

return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
  -- check for possible conflicts: https://www.lazyvim.org/keymaps#copilotchatnvim
  keys = {
    {
      "<leader>aC",
      "<cmd>CodeCompanionChat Toggle<cr>",
      desc = "Toggle Code Companion Chat",
    },
  },
  opts = {
    -- prompt_library = prompts.fuck,
    prompt_library = prompts.prompt_library,
    strategies = {
      chat = {
        adapter = "anthropic",
        keymaps = {
          close = {
            modes = {
              n = "q",
            },
            index = 3,
            callback = "keymaps.close",
            description = "Close Chat",
          },
          stop = {
            modes = {
              n = "<C-c>",
            },
            index = 4,
            callback = "keymaps.stop",
            description = "Stop Request",
          },
        },
      },
      inline = {
        adapter = "anthropic",
      },
      agent = {
        adapter = "anthropic",
      },
    },
    adapters = {
      opts = (function()
        local http_proxy = os.getenv("http_proxy")
        if http_proxy then
          return {
            proxy = http_proxy,
            show_model_choices = true,
          }
        end
        return {
          show_model_choices = true,
        }
      end)(),
      gemini = function()
        return require("codecompanion.adapters").extend("gemini", {
          schema = {
            model = {
              default = "gemini-2.5-pro-exp-03-25",
            },
          },
        })
      end,
    },
    opts = {
      log_level = "DEBUG",
    },
  },
}
