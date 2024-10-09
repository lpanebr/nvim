return -- change some telescope options and a keymap to browse plugin files
{
  "nvim-telescope/telescope.nvim",
  lazy = false,
  keys = {
    {
      -- Browse my .local/bin files
      "<leader>fB",
      function()
        require("telescope.builtin").find_files({
          prompt_title = "~/.local/bin/ Files",
          cwd = "/home/lpanebr/.local/bin/",
        })
      end,
      desc = "Bin Files",
    },
    {
      -- Browse my dotfiles
      "<leader>fd",
      function()
        require("telescope.builtin").find_files({ prompt_title = "~/.dotfiles/ Files", cwd = "/home/lpanebr/.dotfiles" })
      end,
      desc = "Dotfiles",
    },
  },
  opts = {
    defaults = {
      layout_strategy = "horizontal",
      layout_config = { prompt_position = "top" },
      sorting_strategy = "ascending",
      winblend = 10,
    },
    pickers = {
      git_commits = {
        git_command = {
          "git",
          "log",
          "--pretty=oneline",
          "--abbrev-commit",
          "--pretty=format:%h %s %d(%cr - %an)",
          "--date=relative",
          "--",
          ".",
        },
      },
      buffers = {
        layout_config = { prompt_position = "top", anchor = "NW" },
        initial_mode = "normal",
        sort_lastused = true,
        sort_mru = true,
        mappings = {
          n = {
            ["d"] = require("telescope.actions").delete_buffer,
          },
        },
      },
      find_files = {
        -- Search inside hidden directories nd follow symlinks.
        find_command = { "rg", "--files", "--hidden", "--follow", "--glob", "!**/.git/*" },
      },
      live_grep = {
        additional_args = function()
          return { "--hidden" }
        end,
      },
      help_tags = {
        attach_mappings = function(prompt_bufnr, map)
          local actions = require("telescope.actions")
          local action_state = require("telescope.actions.state")
          local utils = require("telescope.utils")
          actions.select_default:replace(function(prompt_bufnr)
            local curr_entry = action_state.get_selected_entry()
            if not curr_entry then
              utils.__warn_no_selection("builtin.help_tags")
              return
            end

            actions.close(prompt_bufnr)
            local selection = action_state.get_selected_entry()
            -- print("echo " .. selection.display)
            vim.cmd("vert help " .. selection.display)
          end)
          return true
        end,
      },
    },
  },
}
