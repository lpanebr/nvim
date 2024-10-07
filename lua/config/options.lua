-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.python3_host_prog = vim.fn.expand("~/.pyenv/versions/neovim3/bin/python")

vim.g.git_worktree = {
  change_directory_command = "cd",
  update_on_change = true,
  update_on_change_command = "e .",
  clearjumps_on_change = true,
  confirm_telescope_deletions = true,
  autopush = false,
}
