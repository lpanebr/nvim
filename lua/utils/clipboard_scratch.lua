-- ~/.config/nvim/lua/utils/clipboard_scratch.lua
local api = vim.api
local fn = vim.fn

local M = {}

M.setup_clipboard_scratch = function()
  local tmpfile = "/tmp/nvim_clipboard_scratch"

  -- 1) Abre (ou cria) o arquivo em /tmp
  api.nvim_command("edit " .. tmpfile)

  -- 2) Ajusta opções do buffer
  local bufnr = api.nvim_get_current_buf()
  vim.bo[bufnr].swapfile = false
  vim.bo[bufnr].filetype = "markdown"
  api.nvim_buf_set_name(bufnr, tmpfile)

  -- 3) Autocmd para, depois do write, copiar pro clipboard
  api.nvim_create_autocmd("BufWritePost", {
    pattern = tmpfile,
    callback = function()
      -- usa xclip (X11) ou wl-copy (Wayland)
      local copy_cmd = vim.fn.executable("wl-copy") == 1 and "wl-copy < " .. tmpfile
        or "xclip -selection clipboard < " .. tmpfile
      fn.system(copy_cmd)
      vim.notify("📋 Conteúdo copiado para o clipboard")
    end,
    desc = "Copy /tmp/nvim_clipboard_scratch to system clipboard",
  })
end

return M
