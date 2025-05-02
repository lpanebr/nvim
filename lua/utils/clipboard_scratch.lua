local api = vim.api
local bo = vim.bo -- Alias para vim.bo para concisão

local M = {}

M.setup_clipboard_scratch = function()
  -- Cria um novo buffer vazio
  api.nvim_command("enew")

  -- Define algumas opções para o buffer temporário usando vim.bo
  -- bo é local ao buffer atual (0) por padrão
  bo.buflisted = false -- Não listar em :ls
  bo.bufhidden = "wipe" -- Remover buffer ao fechar janela
  bo.swapfile = false -- Não criar swap file
  bo.modifiable = true -- Garantir que é modificável

  -- Opcional: definir um nome para o buffer para identificação
  api.nvim_buf_set_name(0, "clipboard://temp")

  -- Cria um autocomando para o evento BufWriteCmd neste buffer
  api.nvim_create_autocmd("BufWriteCmd", {
    buffer = 0, -- Aplica ao buffer atual (o recém-criado)
    callback = function()
      -- Copia o conteúdo do buffer para o system clipboard
      -- '%y+' yank (copia) o buffer inteiro para o registro '+' (clipboard do sistema)
      api.nvim_command("%y+")
      print("Conteúdo copiado para o clipboard!")
      -- Opcional: fechar a janela após copiar
      api.nvim_command("q")
    end,
    desc = "Copy buffer content to system clipboard on save",
  })

  print("Buffer temporário para clipboard criado. Salve para copiar.")
end

return M
