return {
  "mzlogin/vim-markdown-toc",
  cmd = { "GenTocGFM", "GenTocGitLab", "UpdateToc" },
  init = function()
    vim.g.vmt_auto_update_on_save = 0
  end,
  ft = { "markdown" },
}
