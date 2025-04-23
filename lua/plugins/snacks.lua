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
            },
            win = {
              preview = { minimal = true },
              input = {
                keys = {
                  ["<c-o>"] = { "xdg_open", mode = { "n", "i" }, desc = "Open external" },
                },
              },
              list = {
                keys = {
                  ["<c-o>"] = { "xdg_open", mode = { "n", "i" }, desc = "Open external" },
                },
              },
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
