local goDocPrompt = [[
Create documentation for the following Golang code following these guidelines:

1. Package Documentation:
- Begin with a clear, single-sentence summary
- Follow with a more detailed description if needed
- Include any important usage notes or examples
- Use complete sentences and proper grammar

2. Function/Method Documentation:
- Start with the function name and a verb describing what it does
- Include any error conditions or edge cases
- Document any side effects
- Add example usage if non-obvious

3. Style Requirements:
- Follow Go's official documentation style
- Use present tense
- Be concise but complete
- Include any relevant links to external documentation
- Document exported identifiers thoroughly
- Use idiomatic Go terminology

4. Format:
- Use proper godoc formatting
- Include code examples where helpful
- Group related items logically
- Maintain consistent indentation and spacing

Additional requirements:
- Mention thread-safety if applicable
- Include any relevant package dependencies
- Return only the documentation and the signature of the function
]]

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
    prompt_library = {
      ["Documentation"] = {
        strategy = "chat",
        description = "Create or update Documentation",
        opts = {
          mapping = "<LocalLeader>ce",
          modes = { "v" },
          short_name = "documentation",
          auto_submit = true,
          stop_context_insertion = true,
          user_prompt = true,
        },
        prompts = {
          {
            role = "system",
            content = function(context)
              return goDocPrompt
            end,
          },
          {
            role = "user",
            content = function(context)
              local text = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

              return "Please document the following code:\n\n```" .. context.filetype .. "\n" .. text .. "\n```\n\n"
            end,
            opts = {
              contains_code = true,
            },
          },
        },
      },
    },
    strategies = {
      chat = {
        adapter = "gemini",
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
        adapter = "gemini",
      },
      agent = {
        adapter = "gemini",
      },
    },
    adapters = {
      opts = (function()
        local http_proxy = os.getenv("http_proxy")
        if http_proxy then
          return { proxy = http_proxy }
        end
        return {}
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
