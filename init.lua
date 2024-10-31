-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

require("lspconfig").lemminx.setup({
  settings = {
    xml = {
      catalogs = { "/home/lpanebr/catalogs/catalog.xml" },
      validation = {
        resolveExternalEntities = true,
      },
      completion = {
        autoCloseTags = true,
      },
      format = {
        splitAttributes = true,
        joinCDATALines = false,
        joinContentLines = false,
        joinCommentLines = false,
        spaceBeforeEmptyCloseTag = false,
        enabled = true,
      },
      capabilities = {
        formatting = true,
      },
    },
  },
})

-- php Blade syntax highlight
-- https://github.com/EmranMR/tree-sitter-blade/discussions/19#discussion-5400675
local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.blade = {
  install_info = {
    url = "https://github.com/EmranMR/tree-sitter-blade", -- local path or git repo
    files = { "src/parser.c" }, -- note that some parsers also require src/scanner.c or src/scanner.cc
    -- optional entries:
    branch = "main", -- default branch in case of git repo if different from master
    -- generate_requires_npm = false, -- if stand-alone parser without npm dependencies
    requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
  },
  filetype = "blade", -- if filetype does not match the parser name
}

-- Tentei deixar o bg das WinBar transparente.
-- Funciona via comando, mas não por aqui...
vim.cmd(string.format([[highlight WinBar guibg=%s]], "NONE"))
vim.cmd(string.format([[highlight WinBarNC guibg=%s]], "NONE"))
