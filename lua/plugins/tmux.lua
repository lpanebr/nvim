return {
  -- Better window navigation
  "christoomey/vim-tmux-navigator",
  lazy = false,
  keys = {
    { "<C-l>", ":TmuxNavigateRight<CR>", desc = "Tmux nav Right" },
    { "<C-j>", ":TmuxNavigateDown<CR>", desc = "Tmux nav Down" },
    { "<C-k>", ":TmuxNavigateUp<CR>", desc = "Tmux nav Up" },
    { "<C-h>", ":TmuxNavigateLeft<CR>", desc = "Tmux nav Left" },
  },
}
