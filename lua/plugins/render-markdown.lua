-- Filename: ~/github/dotfiles-latest/neovim/neobean/lua/plugins/render-markdown.lua
-- ~/github/dotfiles-latest/neovim/neobean/lua/plugins/render-markdown.lua

-- https://github.com/MeanderingProgrammer/markdown.nvim
--
-- When I hover over markdown headings, this plugins goes away, so I need to
-- edit the default highlights
-- I tried adding this as an autocommand, in the options.lua
-- file, also in the markdownl.lua file, but the highlights kept being overriden
-- so the inly way is the only way I was able to make it work was loading it
-- after the config.lazy in the init.lua file lamw25wmal

return {
  "MeanderingProgrammer/render-markdown.nvim",
  enabled = true,
  -- Moved highlight creation out of opts as suggested by plugin maintainer
  -- There was no issue, but it was creating unnecessary noise when ran
  -- :checkhealth render-markdown
  -- https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/138#issuecomment-2295422741
  init = function()
    local color1_bg = "#062010" -- H5 (verde mais escuro ainda, +50% preto)
    local color2_bg = "#062018" -- H6 (verde-azulado ainda mais escuro, +50% preto)
    local color3_bg = "#1b2014" -- H4 (verde claro muito mais escuro, +50% preto)
    local color4_bg = "#201800" -- H3 (amarelo suave muito mais escuro, +50% preto)
    local color5_bg = "#201103" -- H2 (mais escuro que H1, +50% preto)
    local color6_bg = "#200a06" -- H1 (cor de destaque ainda mais escura, +50% preto)

    local color1_fg = "#33FF57" -- H5 (verde mais escuro)
    local color2_fg = "#33FFBD" -- H6 (verde-azulado suave)
    local color3_fg = "#DAF7A6" -- H4 (verde claro)
    local color4_fg = "#FFC300" -- H3 (amarelo suave)
    local color5_fg = "#FF8D1A" -- H2 (cor menos intensa que H1)
    local color6_fg = "#FF5733" -- H1 (cor de destaque)

    -- Heading colors (when not hovered over), extends through the entire line
    vim.cmd(string.format([[highlight Headline1Bg guifg=%s guibg=%s]], color1_fg, color1_bg))
    vim.cmd(string.format([[highlight Headline2Bg guifg=%s guibg=%s]], color2_fg, color2_bg))
    vim.cmd(string.format([[highlight Headline3Bg guifg=%s guibg=%s]], color3_fg, color3_bg))
    vim.cmd(string.format([[highlight Headline4Bg guifg=%s guibg=%s]], color4_fg, color4_bg))
    vim.cmd(string.format([[highlight Headline5Bg guifg=%s guibg=%s]], color5_fg, color5_bg))
    vim.cmd(string.format([[highlight Headline6Bg guifg=%s guibg=%s]], color6_fg, color6_bg))

    -- Highlight for the heading and sign icons (symbol on the left)
    -- I have the sign disabled for now, so this makes no effect
    vim.cmd(string.format([[highlight Headline1Fg cterm=bold gui=bold guifg=%s]], color1_bg))
    vim.cmd(string.format([[highlight Headline2Fg cterm=bold gui=bold guifg=%s]], color2_bg))
    vim.cmd(string.format([[highlight Headline3Fg cterm=bold gui=bold guifg=%s]], color3_bg))
    vim.cmd(string.format([[highlight Headline4Fg cterm=bold gui=bold guifg=%s]], color4_bg))
    vim.cmd(string.format([[highlight Headline5Fg cterm=bold gui=bold guifg=%s]], color5_bg))
    vim.cmd(string.format([[highlight Headline6Fg cterm=bold gui=bold guifg=%s]], color6_bg))
  end,
  opts = {
    preset = "obsidian",
    bullet = {
      -- Turn on / off list bullet rendering
      enabled = true,
      -- Replaces '-'|'+'|'*' of 'list_item'
      -- How deeply nested the list is determines the 'level'
      -- The 'level' is used to index into the list using a cycle
      -- If the item is a 'checkbox' a conceal is used to hide the bullet instead
      icons = { "●", "○", "◆", "◇" },
      -- Padding to add to the left of bullet point
      left_pad = 1,
      -- Padding to add to the right of bullet point
      right_pad = 1,
      -- Highlight for the bullet icon
      highlight = "RenderMarkdownBullet",
    },
    indent = {
      -- Turn on / off org-indent-mode
      enabled = true,
      -- Amount of additional padding added for each heading level
      per_level = 4,
      -- Heading levels <= this value will not be indented
      -- Use 0 to begin indenting from the very first level
      skip_level = 1,
      -- Do not indent heading titles, only the body
      skip_heading = false,
      icon = "",
    },
    completions = { lsp = { enabled = true } },
    heading = {
      sign = false,
      icons = { "󰲡   ", "󰲣   ", "󰲥   ", "󰲧   ", "󰲩   ", "󰲫   " },
      -- icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎱 ", "󰎳 " },
      width = "block",
      signs = { "󰫎 " },
      left_pad = 1,
      right_pad = 1,
      border = true,
      backgrounds = {
        "Headline1Bg",
        "Headline2Bg",
        "Headline3Bg",
        "Headline4Bg",
        "Headline5Bg",
        "Headline6Bg",
      },
      foregrounds = {
        "Headline1Fg",
        "Headline2Fg",
        "Headline3Fg",
        "Headline4Fg",
        "Headline5Fg",
        "Headline6Fg",
      },
    },
  },
}
