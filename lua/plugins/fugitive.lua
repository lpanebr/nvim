return {
  "tpope/vim-fugitive",
  cmd = { "Git", "Gdiffsplit", "Gread", "Gwrite", "Ggrep", "GMove", "GDelete", "GBrowse" },
  keys = {
    { "<leader>gS", "<cmd>Git<cr>", desc = "Git Fugitive Status" },
    { "<leader>gD", "<cmd>vertical Gdiffsplit<cr>", desc = "Git Fugitive Diffsplit" },
  },
}
