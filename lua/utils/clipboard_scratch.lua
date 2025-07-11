local api = vim.api
local fn = vim.fn

local M = {}

M.setup_clipboard_scratch = function()
  local tmpfile = "/tmp/nvim_clipboard_scratch"

  -- 1) Abre (ou cria) o arquivo em /tmp
  api.nvim_command("edit " .. tmpfile)
  local bufnr = api.nvim_get_current_buf()

  -- 1.5) Limpa o conteúdo do buffer
  api.nvim_buf_set_lines(bufnr, 0, -1, false, {})
  vim.cmd("startinsert")
  vim.cmd("set nocursorcolumn")
  vim.cmd("set signcolumn=no")
  vim.cmd("set numberwidth=1")
  vim.cmd("set nonumber")
  vim.cmd("set norelativenumber")

  -- 2) Ajusta opções do buffer
  vim.bo[bufnr].swapfile = false
  vim.bo[bufnr].filetype = "markdown"
  api.nvim_buf_set_name(bufnr, tmpfile)

  -- 3) Autocmd para, depois do write, copiar pro clipboard
  api.nvim_create_autocmd("BufWritePost", {
    pattern = tmpfile,
    callback = function()
      -- usa wl-copy (Wayland) ou xclip (X11)
      local copy_cmd = fn.executable("wl-copy") == 1 and "wl-copy < " .. tmpfile
        or "xclip -selection clipboard < " .. tmpfile
      fn.system(copy_cmd)
      vim.notify("📋 Conteúdo copiado para o clipboard")
    end,
    desc = "Copy /tmp/nvim_clipboard_scratch to system clipboard",
  })
end

return M
