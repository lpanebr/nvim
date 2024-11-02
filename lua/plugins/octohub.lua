return {
  "2kabhishek/octohub.nvim",
  cmd = {
    "OctoRepos",
    "OctoRepo",
    "OctoStats",
    "OctoActivityStats",
    "OctoContributionStats",
    "OctoRepoStats",
    "OctoProfile",
    "OctoRepoWeb",
  },
  keys = {
    { "<leader>toa", "<cmd>OctoActivityStats<cr>", desc = "Octo activity stats" },
    "<leader>toc",
    "<leader>tof",
    "<leader>tog",
    "<leader>toh",
    "<leader>toi",
    "<leader>too",
    "<leader>top",
    { "<leader>tor", "<cmd>OctoRepos<cr>", desc = "Octo repositories" },
    "<leader>tos",
    "<leader>tot",
    "<leader>tou",
    "<leader>tow",
  },
  dependencies = {
    "2kabhishek/utils.nvim",
    "nvim-telescope/telescope.nvim",
  },
  opts = {},
  config = function()
    local octohub = require("octohub")
    octohub.setup({
      contribution_icons = { "", "", "", "", "", "", "" }, -- Icons for different contribution levels
      projects_dir = "~/Projects/", -- Directory where repositories are cloned
      per_user_dir = true, -- Create a directory for each user
      sort_repos_by = "", -- Sort repositories by various parameters
      repo_type = "", -- Type of repositories to display
      max_contributions = 50, -- Max number of contributions per day to use for icon selection
      top_lang_count = 5, -- Number of top languages to display in stats
      event_count = 5, -- Number of activity events to show
      window_width = 90, -- Width in percentage of the window to display stats
      window_height = 60, -- Height in percentage of the window to display stats
      show_recent_activity = true, -- Show recent activity in the stats window
      show_contributions = true, -- Show contributions in the stats window
      show_repo_stats = true, -- Show repository stats in the stats window
      events_cache_timeout = 3600 * 6, -- Time in seconds to cache activity events
      contributions_cache_timeout = 3600 * 6, -- Time in seconds to cache contributions data
      repo_cache_timeout = 3600 * 24 * 7, -- Time in seconds to cache repositories
      username_cache_timeout = 3600 * 24 * 7, -- Time in seconds to cache username
      user_cache_timeout = 3600 * 24 * 7, -- Time in seconds to cache user data
      add_default_keybindings = true, -- Add default keybindings for the plugin
    })
  end,
}
