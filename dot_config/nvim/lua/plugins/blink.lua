-- Blink Reference: https://cmp.saghen.dev/configuration/reference
return {
  "saghen/blink.cmp",
  opts = {
    keymap = {
      ['<C-j>'] = { 'select_next', 'fallback' },
      ['<C-k>'] = { 'select_prev', 'fallback' },
    },
    cmdline = {
      keymap = {
        ['<C-j>'] = { 'select_next', 'fallback' },
        ['<C-k>'] = { 'select_prev', 'fallback' },
      },
    },
  },
}
