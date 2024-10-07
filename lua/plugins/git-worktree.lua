return {
  "polarmutex/git-worktree.nvim",
  version = "^2",
  branch = "main",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },

  config = function()
    require("telescope").load_extension("git_worktree")

    vim.keymap.set("n", "<leader>gww", require("telescope").extensions.git_worktree.git_worktree, {
      desc = "List [g]it [w]orktrees",
    })
    vim.keymap.set("n", "<leader>gwc", require("telescope").extensions.git_worktree.create_git_worktree, {
      desc = "List [g]it [W]orktrees and create new worktree",
    })

    local Hooks = require("git-worktree.hooks")

    Hooks.register(Hooks.type.SWITCH, function(path, prev_path)
      print(prev_path .. "  ~>  " .. path)
      if vim.fn.expand("%") ~= "" then
        Hooks.builtins.update_current_buffer_on_switch(path, prev_path)
      end
    end)
  end,
}
