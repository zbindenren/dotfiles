local status_ok, cc = pcall(require, 'codecompanion')
if not status_ok then
  vim.notify('codecompanion plugin not found!')
  return
end


cc.setup({
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
