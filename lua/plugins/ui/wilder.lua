local status_ok, wilder = pcall(require, 'wilder')
if not status_ok then
  return
end

wilder.setup({
  modes = { ':', '/', '?' },
  next_key = '<C-j>',
  previous_key = '<C-k>',
})

wilder.set_option('pipeline', {
  wilder.branch(
    wilder.python_file_finder_pipeline({
      file_command = { 'rg', '--files', '--hidden' },
      dir_command = { 'fd', '-td' },
      filters = { 'fuzzy_filter', 'difflib_sorter' },
    }),
    wilder.cmdline_pipeline({ language = 'python', fuzzy = 1 }),
    wilder.python_search_pipeline({
      pattern = wilder.python_fuzzy_delimiter_pattern(),
      sorter = wilder.python_difflib_sorter(),
      engine = 're',
    })
  ),
})

wilder.set_option(
  "renderer",
  wilder.popupmenu_renderer(wilder.popupmenu_border_theme({
    highlighter = wilder.basic_highlighter(),
    pumblend = 5,
    min_width = "50%",
    min_height = "20%",
    max_height = "20%",
    border = "rounded",
    left = { " ", wilder.popupmenu_devicons() },
    right = { " ", wilder.popupmenu_scrollbar() },
  }))
)
