local ngit_status_ok, ngit = pcall(require, "neogit")
if not ngit_status_ok then
  vim.notify("neogit plugin not found!")
  return
end

ngit.setup {
  use_default_keymaps = true,
  disable_hint = false,
  disable_context_highlighting = false,
  disable_signs = false,
  graph_style = "ascii",
  filewatcher = {
    enabled = true,
  },
  telescope_sorter = function()
    return nil
  end,
  git_services = {
    ["github.com"] = "https://github.com/${owner}/${repository}/compare/${branch_name}?expand=1",
    ["bitbucket.org"] = "https://bitbucket.org/${owner}/${repository}/pull-requests/new?source=${branch_name}&t=1",
    ["gitlab.com"] = "https://gitlab.com/${owner}/${repository}/merge_requests/new?merge_request[source_branch]=${branch_name}",
  },
  highlight = {
    italic = true,
    bold = true,
    underline = true,
  },
  disable_insert_on_commit = "auto",
  use_per_project_settings = true,
  show_head_commit_hash = true,
  remember_settings = true,
  fetch_after_checkout = false,
  auto_refresh = true,
  sort_branches = "-committerdate",
  kind = "tab",
  disable_line_numbers = true,
  -- The time after which an output console is shown for slow running commands
  console_timeout = 7000,
  -- Automatically show console if a command takes more than console_timeout milliseconds
  auto_show_console = true,
  notification_icon = "󰊢",
  status = {
    recent_commit_count = 10,
  },
  commit_editor = {
    kind = "tab",
  },
  commit_select_view = {
    kind = "tab",
  },
  commit_view = {
    kind = "vsplit",
    verify_commit = vim.fn.executable("gpg") == 1,
  },
  log_view = {
    kind = "tab",
  },
  rebase_editor = {
    kind = "auto",
  },
  reflog_view = {
    kind = "tab",
  },
  merge_editor = {
    kind = "auto",
  },
  description_editor = {
    kind = "auto",
  },
  tag_editor = {
    kind = "auto",
  },
  preview_buffer = {
    kind = "split",
  },
  popup = {
    kind = "split",
  },
  refs_view = {
    kind = "tab",
  },
  signs = {
    hunk = { "", "" },
    item = { ">", "v" },
    section = { ">", "v" },
  },
  integrations = {
    telescope = nil,
    diffview = nil,
    fzf_lua = nil,
  },
  sections = {
    sequencer = {
      folded = false,
      hidden = false,
    },
    bisect = {
      folded = false,
      hidden = false,
    },
    untracked = {
      folded = false,
      hidden = false,
    },
    unstaged = {
      folded = false,
      hidden = false,
    },
    staged = {
      folded = false,
      hidden = false,
    },
    stashes = {
      folded = true,
      hidden = false,
    },
    unpulled_upstream = {
      folded = true,
      hidden = false,
    },
    unmerged_upstream = {
      folded = false,
      hidden = false,
    },
    unpulled_pushRemote = {
      folded = true,
      hidden = false,
    },
    unmerged_pushRemote = {
      folded = false,
      hidden = false,
    },
    recent = {
      folded = true,
      hidden = false,
    },
    rebase = {
      folded = true,
      hidden = false,
    },
  },
  ignored_settings = {
    "NeogitPushPopup--force-with-lease",
    "NeogitPushPopup--force",
    "NeogitPullPopup--rebase",
    "NeogitCommitPopup--allow-empty",
  },
}

local group = vim.api.nvim_create_augroup('CloseNeoginOnPush', { clear = true })
vim.api.nvim_create_autocmd('User', {
  pattern = 'NeogitPushComplete',
  group = group,
  callback = ngit.close,
})
