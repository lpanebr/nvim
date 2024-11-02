return {
  "tokyonight.nvim",
  opts = {
    setup = {
      require("tokyonight").setup({
        transparent = true,
        on_colors = function(colors) end,
        on_highlights = function(highlights, colors) end,
      }),
    },
  },
}
