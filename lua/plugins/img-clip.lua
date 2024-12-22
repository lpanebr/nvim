return {
  "HakonHarnes/img-clip.nvim",
  event = "VeryLazy",
  opts = {
    default = {
      -- file and directory options
      dir_path = "", ---@type string | fun(): string
      extension = "png", ---@type string | fun(): string
      file_name = "%Y-%m-%d-%H-%M-%S", ---@type string | fun(): string
      use_absolute_path = false, ---@type boolean | fun(): boolean
      relative_to_current_file = true, ---@type boolean | fun(): boolean
      prompt_for_file_name = false, ---@type boolean | fun(): boolean
    },
    -- For project specific settings:
    -- https://github.com/HakonHarnes/img-clip.nvim?tab=readme-ov-file#project-specific-settings-with-the-img-cliplua-file
  },
  keys = {
    -- suggested keymap
    { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
  },
}
