local status_ok, cc = pcall(require, 'codecompanion')
if not status_ok then
  vim.notify('codecompanion plugin not found!')
  return
end

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


cc.setup({
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
          }
        },
      },
    },
  },
  strategies = {
    chat = {
      adapter = 'openai',
    },
    inline = {
      adapter = 'openai',
    },
    agent = {
      adapter = 'openai',
    },
  },
  adapters = {
    opts = {
      proxy = 'http://127.0.0.1:9999',
    },
    openai = function()
      return require('codecompanion.adapters').extend('openai', {
        env = {
          api_key = 'OPENAI_API_KEY'
        },
      })
    end,
    anthropic = function()
      return require('codecompanion.adapters').extend('anthropic', {
        env = {
          api_key = 'ANTHROPIC_API_KEY'
        },
      })
    end,
  },
  opts = {
    log_level = 'DEBUG'
  },
})
