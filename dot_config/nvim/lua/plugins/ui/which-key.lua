local status_ok, which_key = pcall(require, 'which-key')
if not status_ok then
  return
end

local icons = require('lib.icons')

which_key.setup()
which_key.add({
  { '<leader>e', '<cmd>NvimTreeToggle<cr>', icon = icons.documents.OpenFolder, desc = 'explorer' },
  { '<leader>w', '<cmd>w<cr>',              icon = icons.ui.Save,              desc = 'write file' },
  { '<leader>Q', '<cmd>qa!<cr>',            icon = icons.ui.Power,             desc = 'force quit' },
})

which_key.add({
  { '<leader>b',  group = 'Buffers',                                                                                                                      icon = icons.documents.FileEmpty },
  { '<leader>bb', '<cmd>lua require"telescope.builtin".buffers(require("telescope.themes").get_dropdown({ previewer = false, sort_lastused=true }))<cr>', desc = 'list buffers' },
  { '<leader>bc', '<cmd>:BWipeout other<cr>',                                                                                                             desc = 'close all buffers except current' },
  { '<leader>bC', '<cmd>:BWipeout all<cr>',                                                                                                               desc = 'close all buffers' },
})

which_key.add({
  { '<leader>f',  group = 'Find',                                                         icon = icons.ui.Telescope },
  { '<leader>ff', '<cmd>NvimTreeFindFile<cr>',                                            desc = 'find current file' },
  { '<leader>fg', '<cmd>lua require("telescope").extensions.menufacture.live_grep()<cr>', desc = 'find current file' },
  { '<leader>fh', '<cmd>Telescope help_tags<cr>',                                         desc = 'find help' },
})

which_key.add({
  { '<leader>v',  group = 'VersionControl',                                                                                                   icon = icons.git.Octoface },
  { '<leader>va', '<cmd>Gitsigns stage_hunk<cr>',                                                                                             desc = 'stage hunk' },
  { '<leader>vg', '<cmd>lua require("gitlinker").get_buf_range_url("v", {action_callback = require"gitlinker.actions".open_in_browser})<cr>', desc = 'open file in browser' },
  { '<leader>vf', '<cmd>:Telescope git_status<cr>',                                                                                           desc = 'changed files (status)' },
  { '<leader>vl', '<cmd>Fterm lazygit<cr>',                                                                                                   desc = 'open lazygit' },
  { '<leader>vb', '<cmd>Gitsigns blame_line<cr>',                                                                                             desc = 'blame current line' },
  { '<leader>vo', '<cmd>Neogit<cr>',                                                                                                          desc = 'Open neogit' },
  { '<leader>vd', '<cmd>DiffviewOpen<cr>',                                                                                                    desc = 'Open diffsplit' },
  { '<leader>vc', '<cmd>DiffviewClose<cr>',                                                                                                   desc = 'Close diffsplit' },
  { '<leader>vp', '<cmd>Gitsigns preview_hunk<cr>',                                                                                           desc = 'Preview hunk' },
  { '<leader>vr', '<cmd>Gitsigns reset_hunk<cr>',                                                                                             desc = 'Reset hunk' },
  { '<leader>vk', '<cmd>Gitsigns prev_hunk<cr>',                                                                                              desc = 'Previous hunk' },
  { '<leader>vj', '<cmd>Gitsigns next_hunk<cr>',                                                                                              desc = 'Next hunk' },
})

which_key.add({
  { '<leader>l',  group = 'LSP',                                      icon = icons.ui.Gear },
  { '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<cr>',           desc = 'code action' },
  { '<leader>lc', '<cmd>Navbuddy<cr>',                                desc = 'Navbuddy' },
  { '<leader>lG', '<cmd>Telescope lsp_references<cr>',                desc = 'References' },
  { '<leader>li', '<cmd>Telescope diagnostics<cr>',                   desc = 'Diagnostics' },
  { '<leader>lj', '<cmd>lua vim.diagnostic.goto_next()<cr>',          desc = 'Next Diagnostic' },
  { '<leader>lk', '<cmd>lua vim.diagnostic.goto_prev()<cr>',          desc = 'Prev Diagnostic' },
  { '<leader>ll', "<cmd>ToggleDiagnosticVirtualText<cr>",             desc = 'Toggle LSP Lines' },
  { '<leader>lL', '<cmd>LspInfo<cr>',                                 desc = 'LSP Info' },
  { '<leader>lR', '<cmd>LspRestart<cr>',                              desc = 'LSP Restart' },
  { '<leader>lp', '<cmd>Telescope lsp_incoming_calls<cr>',            desc = 'Incoming Calls' },
  { '<leader>lP', '<cmd>Telescope lsp_outgoing_calls<cr>',            desc = 'Outgoing Calls' },
  { '<leader>lr', '<cmd>lua vim.lsp.buf.rename()<cr>',                desc = 'Rename variable' },
  { '<leader>ls', '<cmd>Telescope lsp_document_symbols<cr>',          desc = 'Document Symbols' },
  { '<leader>lS', '<cmd>Telescope lsp_dynamic_workspace_symbols<cr>', desc = 'Workspace Symbols' },
})

which_key.add({
  { '<leader>p',  group = 'Project',                     icon = icons.ui.Project },
  { '<leader>po', '<cmd>Fterm lab open; sleep 1<cr>',    desc = 'open gitlab project in browser' },
  { '<leader>pp', '<cmd>Fterm lab open -p; sleep 1<cr>', desc = 'Open pipeline in browser' },
  { '<leader>pP', '<cmd>Fterm lab ci<cr>',               desc = 'Open project in teminal' },
})

which_key.add({
  { '<leader>T',  group = 'Terminal', icon = icons.ui.Terminal },
  { '<leader>Ts', '<cmd>Sterm<cr>',   desc = 'Horizontal Terminal' },
  { '<leader>Tt', '<cmd>Fterm<cr>',   desc = 'Terminal' },
  { '<leader>Tv', '<cmd>Vterm<cr>',   desc = 'Vertical Terminal' },
})

which_key.add({
  { '<leader>t',  group = 'Test',                                                         icon = icons.ui.Test },
  { '<leader>ta', '<cmd>Fterm gotestsum -- -short ./... -count=1 ; sleep infinity<cr>',   desc = 'Run all tests in terminal' },
  { '<leader>tf', '<cmd>lua require("neotest").run.run(vim.fn.expand("%"))<cr>',          desc = 'Run current file' },
  { '<leader>to', '<cmd>Neotest output-panel<cr>',                                        desc = 'Test Output' },
  { '<leader>tO', '<cmd>Neotest summary<cr>',                                             desc = 'Test Summary' },
  { '<leader>tl', '<cmd>Fterm golangci-lint run -v; sleep infinity<cr>',                  desc = 'Run linter' },
  { '<leader>tt', '<cmd>lua require("neotest").run.run({extra_args = {"-count=1"}})<cr>', desc = 'Run Current Test' },
})


if vim.fn.exists('$TMUX') == 1 then
  which_key.add({
    { '<C-h>', '<cmd>NavigatorLeft<cr>',  desc = 'Move Left' },
    { '<C-j>', '<cmd>NavigatorDown<cr>',  desc = 'Move Down' },
    { '<C-k>', '<cmd>NavigatorUp<cr>',    desc = 'Move Up' },
    { '<C-l>', '<cmd>NavigatorRight<cr>', desc = 'Move Right' },
  })
end
