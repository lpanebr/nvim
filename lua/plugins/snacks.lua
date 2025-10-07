-- Filename: ~/github/dotfiles-latest/neovim/neobean/lua/plugins/snacks.lua
-- ~/github/dotfiles-latest/neovim/neobean/lua/plugins/snacks.lua

-- https://github.com/folke/snacks.nvim/blob/main/docs/lazygit.md
-- https://github.com/folke/snacks.nvim/blob/main/docs/picker.md
-- https://github.com/folke/snacks.nvim/blob/main/docs/image.md

-- NOTE: If you experience an issue in which you cannot select a file with the
-- snacks picker when you're in insert mode, only in normal mode, and you use
-- the bullets.vim plugin, that's the cause, go to that file to see how to
-- resolve it
-- https://github.com/folke/snacks.nvim/issues/812

return {
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>fe",
        function()
          Snacks.picker.icons()
        end,
        desc = "Icons",
      },
      -- I use this keymap with mini.files, but snacks explorer was taking over
      -- https://github.com/folke/snacks.nvim/discussions/949
      {
        "<leader>e",
        function()
          Snacks.explorer()
        end,
        desc = "Snacks Explorer",
      },
      -- Navigate my buffers
      {
        "<leader>fd",
        function()
          Snacks.picker.files({
            -- I always want my buffers picker to start in normal mode
            -- on_show = function()
            --   vim.cmd.stopinsert()
            -- end,
            -- confirm = function(picker, item)
            --   picker:norm(function()
            --     if item then
            --       picker:close()
            --       vim.api.nvim_input(item.item.lhs)
            --     end
            --   end)
            -- end,
            -- patterns = { ".gddoc", ".gdsheet", ".gdlink", ".gdslides" },
            args = {
              "--extension",
              "gddoc",
              "--extension",
              "gdsheet",
              "--extension",
              "gdlink",
              "--extension",
              "gdslides",
            },
            actions = {
              ---@param picker snacks.Picker
              xdg_open = function(picker, item)
                picker:norm(function()
                  if item then
                    -- picker:close()
                    -- vim.notify_once(vim.inspect(item), 1, {})
                    -- vim.notify_once(item._path, 1, {})
                    vim.fn.jobstart({ "xdg-open", item._path }, { detach = true })
                  end
                end)
              end,
              ---@param picker snacks.Picker
              reveal_file_directory = function(picker, item)
                picker:norm(function()
                  if item then
                    vim.cmd("edit " .. vim.fn.fnameescape(item._path))
                    ---@param opts? {file?:string, buf?:number}
                    Snacks.explorer.reveal()
                    picker:close()
                  end
                end)
              end,
            },
            win = {
              preview = { minimal = true },
              input = {
                keys = {
                  ["<c-o>"] = { "xdg_open", mode = { "n", "i" }, desc = "Open external" },
                  ["<c-e>"] = { "reveal_file_directory", mode = { "n", "i" }, desc = "Reveal file directory" },
                },
              },
              list = {
                keys = {
                  ["<c-o>"] = { "xdg_open", mode = { "n", "i" }, desc = "Open external" },
                  ["<c-e>"] = { "reveal_file_directory", mode = { "n", "i" }, desc = "Reveal file directory" },
                },
              },
            },
            -- default para referencia
            preview = "none",
            formatters = {
              text = {
                ft = nil, ---@type string? filetype for highlighting
              },
              file = {
                filename_first = false, -- display filename before the file path
                truncate = 40, -- truncate the file path to (roughly) this length
                filename_only = true, -- only show the filename
                icon_width = 2, -- width of the icon (in characters)
                git_status_hl = true, -- use the git status highlight group for the filename
              },
              selected = {
                show_always = false, -- only show the selected column when there are multiple selections
                unselected = true, -- use the unselected icon for unselected items
              },
              severity = {
                icons = true, -- show severity icons
                level = false, -- show severity level
                ---@type "left"|"right"
                pos = "left", -- position of the diagnostics
              },
            },
            -- default para referencia
            ---@class snacks.picker.matcher.Config
            matcher = {
              fuzzy = true, -- use fuzzy matching
              smartcase = true, -- use smartcase
              ignorecase = true, -- use ignorecase
              sort_empty = false, -- sort results when the search string is empty
              filename_bonus = true, -- give bonus for matching file names (last part of the path)
              file_pos = true, -- support patterns like `file:line:col` and `file:line`
              -- the bonusses below, possibly require string concatenation and path normalization,
              -- so this can have a performance impact for large lists and increase memory usage
              cwd_bonus = false, -- give bonus for matching files in the cwd
              frecency = true, -- frecency bonus
              history_bonus = false, -- give more weight to chronological order
            },
            -- In case you want to override the layout for this keymap
            -- layout = "ivy",
          })
        end,
        desc = "¹ Find Google Drive Files",
      },
    },
    opts = {},
  },
}
