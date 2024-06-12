local status_ok, which_key = pcall(require, 'which-key')
if not status_ok then
  return
end

local icons = require('lib.icons')

local setup = {
  plugins = {
    marks = true,
    registers = true,
    spelling = {
      enabled = true,
      suggestions = 30,
    },
    presets = {
      operators = true,
      motions = true,
      text_objects = true,
      windows = true,
      nav = true,
      z = true,
      g = true,
    },
  },
  key_labels = {
    ['<leader>'] = icons.ui.Rocket .. 'Space',
    ['<space>'] = icons.ui.Rocket .. 'Space',
  },
  icons = {
    breadcrumb = icons.ui.ArrowOpen,
    separator = icons.ui.Arrow,
    group = '',
  },
  popup_mappings = {
    scroll_down = '<c-d>',
    scroll_up = '<c-u>',
  },
  window = {
    border = 'shadow',
    position = 'bottom',
    margin = { 0, 0, 0, 0 },
    padding = { 1, 2, 1, 2 },
    winblend = 10,
  },
  layout = {
    height = { min = 4, max = 24 },
    width = { min = 20, max = 50 },
    spacing = 3,
    align = 'center',
  },
  ignore_missing = false,
  hidden = { '<silent>', '<cmd>', '<Cmd>', '<CR>', '^:', '^ ', '^call ', '^lua ' },
  show_help = true,
  show_keys = true,
  triggers = 'auto',
  triggers_nowait = {
    -- marks
    '`',
    "'",
    'g`',
    "g'",
    -- registers
    '"',
    '<c-r>',
    -- spelling
    'z=',
  },
  triggers_blacklist = {
    i = { 'j', 'j' },
    v = { 'j', 'j' },
  },
}

local i = {
  [' '] = 'Whitespace',
  ['"'] = 'Balanced "',
  ["'"] = "Balanced '",
  ['`'] = 'Balanced `',
  ['('] = 'Balanced (',
  [')'] = 'Balanced ) including white-space',
  ['>'] = 'Balanced > including white-space',
  ['<lt>'] = 'Balanced <',
  [']'] = 'Balanced ] including white-space',
  ['['] = 'Balanced [',
  ['}'] = 'Balanced } including white-space',
  ['{'] = 'Balanced {',
  ['?'] = 'User Prompt',
  _ = 'Underscore',
  a = 'Argument',
  b = 'Balanced ), ], }',
  c = 'Class',
  f = 'Function',
  o = 'Block, conditional, loop',
  q = 'Quote `, ", \'',
  t = 'Tag',
}

local a = vim.deepcopy(i)
for k, v in pairs(a) do
  a[k] = v:gsub(' including.*', '')
end

local ic = vim.deepcopy(i)
local ac = vim.deepcopy(a)

for key, name in pairs({ n = 'Next', l = 'Last' }) do
  i[key] = vim.tbl_extend('force', { name = 'Inside ' .. name .. ' textobject' }, ic)
  a[key] = vim.tbl_extend('force', { name = 'Around ' .. name .. ' textobject' }, ac)
end

local opts = {
  mode = 'n',
  prefix = '<leader>',
  buffer = nil,
  silent = true,
  noremap = true,
  nowait = true,
}

local mappings = {
  e = { '<cmd>NvimTreeToggle<cr>', icons.documents.OpenFolder .. 'Explorer' },
  q = { '<cmd>q<cr>', icons.ui.Close .. 'Quit' },
  Q = { '<cmd>qa!<cr>', icons.ui.Power .. 'Force Quit!' },
  w = { '<cmd>w<cr>', icons.ui.Save .. 'Save' },
  x = { '<cmd>x<cr>', icons.ui.Pencil .. 'Write and Quit' },
  c = {
    name = icons.ui.NeoVim .. 'Config',
    c = { '<cmd>CccConvert<cr>', 'Convert Color' },
    d = { '<cmd>cd %:p:h<cr>', 'Change Directory' },
    e = { '<cmd>e ~/.config/nvim/init.lua<cr>', 'Edit Config' },
    f = { '<cmd>!bundle exec rubocop -A %<cr>', 'Format Files' },
    F = { '<cmd>retab<cr>', 'Fix Tabs' },
    i = { vim.show_pos, 'Inspect Position' },
    l = { '<cmd>:g/^\\s*$/d<cr>', 'Clean Empty Lines' },
    n = { '<cmd>set relativenumber!<cr>', 'Relative Numbers' },
    p = { '<cmd>CccPick<cr>', 'Pick Color' },
    r = { '<cmd>Telescope reloader<cr>', 'Reload Module' },
    R = { '<cmd>ReloadConfig<cr>', 'Reload Configs' },
  },
  b = {
    name = icons.documents.FileEmpty .. 'Buffers',
    b = {
      "<cmd>lua require'telescope.builtin'.buffers(require('telescope.themes').get_dropdown({ previewer = false, sort_lastused=true }))<cr>",
      "list buffers",
    },
    d = { "<cmd>:BWipeout this<cr>", "delete current buffer" },
    c = { "<cmd>:BWipeout other<cr>", "close all buffers except current" },
    C = { "<cmd>:BWipeout all<cr>", "close all buffers" },
  },
  d = {
    name = icons.ui.Database .. 'Database',
    b = { '<cmd>DBToggle<cr>', 'DB Explorer' },
    j = { '<cmd>lua require("dbee").next()<cr>', 'DB Next' },
    k = { '<cmd>lua require("dbee").prev()<cr>', 'DB Prev' },
    s = { '<cmd>lua require("dbee").store("csv", "buffer", { extra_arg = 0 })<cr>', 'To CSV' },
    S = { '<cmd>lua require("dbee").store("json", "buffer", { extra_arg = 0 })<cr>', 'To JSON' },
    t = { '<cmd>lua require("dbee").store("table", "buffer", { extra_arg = 0 })<cr>', 'To Table' },
  },
  f = {
    name = icons.ui.Telescope .. 'Find',
    c = { '<cmd>:Telescope git_status<cr>', 'Find changed files' },
    f = { '<cmd>NvimTreeFindFile<cr>', 'Find current file' },
    g = { '<cmd>lua require("telescope").extensions.menufacture.live_grep()<cr>', 'Find Text' },
    h = { '<cmd>Telescope help_tags<cr>', 'Help' },
    H = { '<cmd>Telescope man_pages<cr>', 'Man Pages' },
    k = { '<cmd>Telescope commands<cr>', 'Commands' },
    K = { '<cmd>Telescope keymaps<cr>', 'Keymaps' },
    l = { '<cmd>lua require("telescope").extensions.menufacture.git_files()<cr>', 'Find files' },
    L = { '<cmd>Telescope loclist<cr>', 'Location List' },
    n = { '<cmd>enew<cr>', 'New File' },
    p = { '<cmd>Telescope<cr>', 'Panel' },
    q = { '<cmd>Telescope quickfix<cr>', 'Quickfix' },
    s = { '<cmd>Telescope live_grep grep_open_files=true<cr>', 'Find in Open Files' },
    u = { '<cmd>Telescope undo<cr>', 'Undo History' },
    ['"'] = { '<cmd>Telescope registers<cr>', 'Registers' },
    ['.'] = { '<cmd>Telescope symbols<cr>', 'Emojis' },
    [','] = { '<cmd>Nerdy<cr>', 'Nerd Glyphs' },
  },
  v = {
    name = icons.git.Octoface .. 'Git',
    a = { '<cmd>Gitsigns stage_hunk<cr>', 'Stage Hunk' },
    f = { '<cmd>:Telescope git_status<cr>', 'Find changed files' },
    l = { "<cmd>Fterm lazygit<cr>", "Open lazygit" },
    b = { '<cmd>Gitsigns blame_line<cr>', 'Blame current line' },
    o = { "<cmd>Neogit<cr>", "Open neogit" },
    d = { "<cmd>DiffviewOpen<cr>", "Open diffsplit" },
    c = { "<cmd>DiffviewClose<cr>", "Close diffsplit" },
    p = { "<cmd>Gitsigns preview_hunk<cr>", "Preview hunk" },
    r = { "<cmd>Gitsigns reset_hunk<cr>", "Reset hunk" },
    k = { "<cmd>Gitsigns prev_hunk<cr>", "Previous hunk" },
    j = { "<cmd>Gitsigns next_hunk<cr>", "Next hunk" },
    t = {
      name = 'Git Toggle',
      b = { '<cmd>Gitsigns toggle_current_line_blame<cr>', 'Blame' },
      d = { '<cmd>Gitsigns toggle_deleted<cr>', 'Deleted' },
      l = { '<cmd>Gitsigns toggle_linehl<cr>', 'Line HL' },
      n = { '<cmd>Gitsigns toggle_numhl<cr>', 'Number HL' },
      s = { '<cmd>Gitsigns toggle_signs<cr>', 'Signs' },
      w = { '<cmd>Gitsigns toggle_word_diff<cr>', 'Word Diff' },
    },
  },
  h = {
    name = icons.ui.Bookmark .. 'Harpoon',
    a = { '<cmd>lua require("harpoon.mark").add_file()<cr>', 'Harpoon' },
    h = { '<cmd>Telescope harpoon marks<cr>', 'Search Files' },
    m = { '<cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>', 'Harpoon UI' },
    k = { '<cmd>lua require("harpoon.ui").nav_next()<cr>', 'Harpoon Next' },
    j = { '<cmd>lua require("harpoon.ui").nav_prev()<cr>', 'Harpoon Prev' },
  },
  l = {
    name = icons.ui.Gear .. 'LSP',
    a = { '<cmd>lua vim.lsp.buf.code_action()<cr>', 'Code Action' },
    c = { '<cmd>Navbuddy<cr>', 'Navbuddy' },
    G = { '<cmd>Telescope lsp_references<cr>', 'References' },
    i = { '<cmd>Telescope diagnostics<cr>', 'Diagnostics' },
    j = { '<cmd>lua vim.diagnostic.goto_next()<cr>', 'Next Diagnostic' },
    k = { '<cmd>lua vim.diagnostic.goto_prev()<cr>', 'Prev Diagnostic' },
    l = { "<cmd>ToggleDiagnosticVirtualText<cr>", 'Toggle LSP Lines' },
    L = { '<cmd>LspInfo<cr>', 'LSP Info' },
    R = { '<cmd>LspRestart<cr>', 'LSP Restart' },
    p = { '<cmd>Telescope lsp_incoming_calls<cr>', 'Incoming Calls' },
    P = { '<cmd>Telescope lsp_outgoing_calls<cr>', 'Outgoing Calls' },
    r = { '<cmd>lua vim.lsp.buf.rename()<cr>', 'Rename variable' },
    s = { '<cmd>Telescope lsp_document_symbols<cr>', 'Document Symbols' },
    S = { '<cmd>Telescope lsp_dynamic_workspace_symbols<cr>', 'Workspace Symbols' },
  },
  m = {
    name = icons.kind.Field .. 'Modes',
    c = { '<cmd>CccHighlighterToggle<cr>', 'Highlight Colors' },
    d = { '<cmd>Dashboard<cr>', 'Dashboard' },
    h = { '<cmd>Hardtime toggle<cr>', 'Hardtime' },
    m = { '<cmd>MarkdownPreviewToggle<cr>', 'Markdown Preview' },
    n = { '<cmd>Telescope notify<cr>', 'Notifications' },
    r = { '<cmd>%SnipRun<cr>', 'Run File' },
    s = { '<cmd>set spell!<cr>', 'Spellcheck' },
    z = { '<cmd>ZenMode<cr>', 'ZenMode' },
    Z = { '<cmd>Twilight<cr>', 'Twilight' },
  },
  p = {
    name = icons.ui.Project .. 'Project',
    o = { "<cmd>Fterm lab open; sleep 1<cr>", "Open project in browser" },
    p = { "<cmd>Fterm lab open -p; sleep 1<cr>", "Open pipeline in browser" },
    P = { "<cmd>Fterm lab ci<cr>", "Open pipeline in browser" },
  },
  r = {
    name = icons.diagnostics.Hint .. 'Refactor',
    b = { "<cmd>lua require('spectre').open_file_search()<cr>", 'Replace Buffer' },
    e = { "<cmd>lua require('refactoring').refactor('Extract Block')<CR>", 'Extract Block' },
    f = { "<cmd>lua require('refactoring').refactor('Extract Block To File')<CR>", 'Extract To File' },
    i = { "<cmd>lua require('refactoring').refactor('Inline Variable')<CR>", 'Inline Variable' },
    n = { '', 'Swap Next' },
    p = { '', 'Swap Previous' },
    r = { '<cmd>lua vim.lsp.buf.rename()<cr>', 'Rename variable' },
    d = { '', 'Go To Definition' },
    h = { '', 'List Definition Head' },
    l = { '', 'List Definition' },
    j = { '', 'Next Usage' },
    k = { '', 'Previous Usage' },
    R = { "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>", 'Refactor Commands' },
    S = { "<cmd>lua require('spectre').open()<cr>", 'Replace' },
    s = { [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], 'Replace Word' },
    v = { "<cmd>lua require('refactoring').refactor('Extract Variable')<CR>", 'Extract Variable' },
    w = { "<cmd>lua require('spectre').open_visual({select_word=true})<cr>", 'Replace Word' },
  },
  T = {
    name = icons.ui.Terminal .. 'Terminal',
    s = { '<cmd>Sterm<cr>', 'Horizontal Terminal' },
    t = { '<cmd>Fterm<cr>', 'Terminal' },
    v = { '<cmd>Vterm<cr>', 'Vertical Terminal' },
  },
  t = {
    name = icons.ui.Test .. 'Test',
    a = { '<cmd>Fterm gotestsum -- -short ./... -count=1 ; sleep infinity<cr>', 'Run all tests in terminal' },
    f = { '<cmd>lua require("neotest").run.run(vim.fn.expand("%"))<cr>', 'Run current file' },
    o = { '<cmd>Neotest output-panel<cr>', 'Test Output' },
    O = { '<cmd>Neotest summary<cr>', 'Test Summary' },
    l = { '<cmd>Fterm golangci-lint run -v; sleep infinity<cr>', 'Run linter' },
    t = { '<cmd>lua require("neotest").run.run({extra_args = {"-count=1"}})<cr>', 'Run Current Test' },
  },
  s = {
    name = icons.ui.Windows .. 'Split',
    ['-'] = { '<C-w>s', 'Split Below' },
    ['\\'] = { '<C-w>v', 'Split Right' },
    c = { '<cmd>tabclose<cr>', 'Close Tab' },
    d = { '<C-w>c', 'Close Window' },
    f = { '<cmd>tabfirst<cr>', 'First Tab' },
    h = { '<C-w>h', 'Move Left' },
    j = { '<C-w>j', 'Move Down' },
    k = { '<C-w>k', 'Move Up' },
    l = { '<C-w>l', 'Move Right' },
    L = { '<cmd>tablast<cr>', 'Last Tab' },
    o = { '<cmd>tabnext<cr>', 'Next Tab' },
    O = { '<cmd>tabprevious<cr>', 'Previous Tab' },
    p = { '<C-w>p', 'Previous Window' },
    q = { '<cmd>bw<cr>', 'Close Current Buf' },
    s = { '<cmd>split<cr>', 'Horizontal Split File' },
    t = { '<cmd>tabnew<cr>', 'New Tab' },
    v = { '<cmd>vsplit<cr>', 'Vertical Split File' },
    W = { "<cmd>lua require'utils'.sudo_write()<cr>", 'Force Write' },
    w = { '<cmd>w<cr>', 'Write' },
    x = { '<cmd>x<cr>', 'Write and Quit' },
  },
  y = {
    name = icons.ui.Clipboard .. 'Yank',
    f = { '<cmd>%y+<cr>', 'Copy Whole File' },
    p = { '<cmd>CRpath<cr>', 'Copy Relative Path' },
    P = { '<cmd>CApath<cr>', 'Copy Absolute Path' },
    g = { '<cmd>lua require"gitlinker".get_buf_range_url()<cr>', 'Copy Git URL' },
  },
}

local vopts = {
  mode = 'v',
  prefix = '<leader>',
  buffer = nil,
  silent = true,
  noremap = true,
  nowait = true,
}

local vmappings = {
  l = {
    name = icons.ui.Gear .. 'LSP',
    a = '<cmd><C-U>Lspsaga range_code_action<CR>',
  },
  r = {
    name = icons.diagnostics.Hint .. 'Refactor',
    r = { "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>", 'Refactor Commands' },
    e = { "<esc><cmd>lua require('refactoring').refactor('Extract Function')<CR>", 'Extract Function' },
    f = { "<esc><cmd>lua require('refactoring').refactor('Extract Function To File')<CR>", 'Extract To File' },
    v = { "<esc><cmd>lua require('refactoring').refactor('Extract Variable')<CR>", 'Extract Variable' },
    i = { "<esc><cmd>lua require('refactoring').refactor('Inline Variable')<CR>", 'Inline Variable' },
  },
  s = { "<esc><cmd>'<,'>SnipRun<cr>", icons.ui.Play .. 'Run Code' },
  q = { '<cmd>q<cr>', icons.ui.Close .. 'Quit' },
  Q = { '<cmd>qa!<cr>', icons.ui.Power .. 'Force Quit!' },
  x = { '<cmd>x<cr>', icons.ui.Pencil .. 'Write and Quit' },
  y = {
    name = icons.ui.Clipboard .. 'Yank',
    g = { '<cmd>lua require"gitlinker".get_buf_range_url()<cr>', 'Copy Git URL' },
  },
}

local no_leader_opts = {
  mode = 'n',
  prefix = '',
  buffer = nil,
  silent = true,
  noremap = true,
  nowait = true,
}

local no_leader_mappings = {
  ['<S-h>'] = { '<cmd>bprevious<cr>', 'Previous Buffer' },
  ['<S-l>'] = { '<cmd>bnext<cr>', 'Next Buffer' },

  ['<C-h>'] = { '<C-w>h', 'Move Left' },
  ['<C-j>'] = { '<C-w>j', 'Move Down' },
  ['<C-k>'] = { '<C-w>k', 'Move Up' },
  ['<C-l>'] = { '<C-w>l', 'Move Right' },

  ['<C-Up>'] = { '<cmd>resize +10<cr>', 'Increase window height' },
  ['<C-Down>'] = { '<cmd>resize -10<cr>', 'Decrease window height' },
  ['<C-Left>'] = { '<cmd>vertical resize -10<cr>', 'Decrease window width' },
  ['<C-Right>'] = { '<cmd>vertical resize +10<cr>', 'Increase window width' },

  ['<C-f>'] = { '<cmd>Telescope find_files<cr>', 'Find Files' },
  ['<C-g>'] = { '<cmd>Fterm lazygit<cr>', 'Lazygit' },

  ['['] = {
    name = icons.ui.ArrowLeft .. 'Previous',
    b = { '<cmd>bprevious<cr>', 'Previous Buffer' },
    B = { '<cmd>bfirst<cr>', 'First Buffer' },
    e = { 'g;', 'Previous Edit' },
    j = { '<C-o>', 'Previous Jump' },
    h = { '<cmd>lua require("harpoon.ui").nav_prev()<cr>', 'Prev Harpoon' },
  },
  [']'] = {
    name = icons.ui.ArrowRight .. 'Next',
    b = { '<cmd>bnext<cr>', 'Next Buffer' },
    B = { '<cmd>blast<cr>', 'Last Buffer' },
    e = { 'g,', 'Next Edit' },
    j = { '<C-i>', 'Next Jump' },
    h = { '<cmd>lua require("harpoon.ui").nav_next()<cr>', 'Next Harpoon' },
  },

  ['#'] = { '<cmd>edit #<cr>', 'Alternate Buffer' },
  K = { '<cmd>Lspsaga hover_doc<cr>', 'LSP Hover' },
  U = { '<cmd>redo<cr>', 'Redo' },
}

which_key.setup(setup)
which_key.register(mappings, opts)
which_key.register(vmappings, vopts)
which_key.register(no_leader_mappings, no_leader_opts)
which_key.register({ mode = { 'o', 'x' }, i = i, a = a })
