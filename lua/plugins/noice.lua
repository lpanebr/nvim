return {
  "folke/noice.nvim",
  -- defines which plugin to update
  opts = {
    -- allows you to modify the options previously set
    presets = {
      bottom_search = false,
      command_palette = true,
      lsp_doc_border = true,
    },
    views = {
      cmdline_popup = {
        anchor = "SW",
        -- relative = "win",
        -- position = {
        --   row = "5%",
        --   col = "50%",
        -- },
        relative = "cursor",
        position = {
          row = -3,
          col = 20,
        },
      },
    },
  },
  -- Disable noice.nvim scroll
  keys = {
    { "<c-f>", false, mode = { "i", "n", "s" } },
    { "<c-b>", false, mode = { "i", "n", "s" } },
  },
}
