-- lua/plugins/my_highlight.lua
-- Plugin para destacar linhas inteiras com base em uma regex

-- Paleta de cores discretas e compatíveis com temas claros e escuros
local colors = {
  ["gold"] = "#3F3500",
  ["green"] = "#1F3F00",
  ["blue"] = "#07243F",
  ["pink"] = "#3F1A2D",
  ["purple"] = "#220A38",
  ["orange"] = "#3F1100",
  ["teal"] = "#003334",
  ["gray"] = "#343434",
  ["lightblue"] = "#2B3639",
  ["lightgreen"] = "#243B24",
}

local color_keys = vim.tbl_keys(colors)
table.sort(color_keys) -- Ordena os nomes das cores para facilitar a leitura
local current_color_index = 1
local highlight_count = 0

-- Função para destacar linhas inteiras com base em uma regex
local function HighlightRegex()
  -- Solicita a regex ao usuário
  local regex = vim.fn.input("Regex: ")
  if regex == "" then
    print("Regex não fornecida.")
    return
  end

  -- Sugere uma cor da paleta e permite personalização
  local suggested_color = color_keys[current_color_index]
  current_color_index = (current_color_index % #color_keys) + 1
  local chosen_color_name = vim.fn.input("Cor (Padrão: " .. suggested_color .. "): ")
  local chosen_color
  if colors[chosen_color_name] == nil then
    chosen_color = chosen_color_name
  else
    chosen_color = colors[chosen_color_name] or colors[suggested_color]
  end

  -- Incrementa o contador e define o grupo de destaque
  highlight_count = highlight_count + 1
  local group = "MyCustomHighlightGroup" .. highlight_count
  vim.api.nvim_set_hl(0, group, { bg = chosen_color, fg = "NONE" })

  -- Adiciona a correspondência com o grupo de destaque para a linha inteira
  vim.fn.matchadd(group, "\\c^.*" .. regex .. ".*$")
  print("Adicionado destaque para linhas contendo regex:", regex, "com a cor", chosen_color_name or suggested_color)
end

-- Função para limpar todos os destaques
local function ResetHighlights()
  vim.fn.clearmatches()
  highlight_count = 0
  current_color_index = 1
  print("Todos os destaques foram removidos.")
end

-- Cria os comandos para usar as funções
vim.api.nvim_create_user_command("LgpHighlightRegex", HighlightRegex, {})
vim.api.nvim_create_user_command("LgpHighlightReset", ResetHighlights, {})

-- Exibe as cores disponíveis
vim.api.nvim_create_user_command("LgpHighlightColors", function()
  print("Cores disponíveis:")
  for _, color_name in ipairs(color_keys) do
    print(" - " .. color_name)
  end
end, {})
