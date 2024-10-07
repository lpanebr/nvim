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
