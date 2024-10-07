-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

--[[
extendAttributes - A function to extend the attributes of a table.

@param baseAttrs (table) - The base attributes table to be extended.
@param newAttrs (table) - The new attributes table to extend the base attributes.

@return (table) - The extended attributes table.

@throws (string) - If either baseAttrs or newAttrs is not a table.

@usage
local base = {name = "John", age = 30}
local new = {gender = "male", occupation = "engineer"}
local extended = extendAttributes(base, new)
extended = {name = "John", age = 30, gender = "male", occupation = "engineer"}
]]
local function extendAttributes(baseAttrs, newAttrs)
  if type(baseAttrs) ~= "table" then
    error("baseAttrs must be a table", 2)
  end

  if type(newAttrs) ~= "table" then
    error("newAttrs must be a table", 2)
  end

  for key, value in pairs(newAttrs) do
    baseAttrs[key] = value
  end

  return baseAttrs
end

local noremapsilent = { noremap = true, silent = true }

-- Muda ou cria uma nova sessão no tmux.
vim.keymap.set("n", "<c-f>", ":exe '!tmux neww tmux-sessionizer'<cr>", { silent = true, desc = "Tmux sessionizer" })

-- Restaura funcionalidades nativas estragadas pelo LazyVim
vim.keymap.set("n", "H", "H")
vim.keymap.set("n", "L", "L")

-- move selection: The Primeagen
vim.keymap.set("v", "<M-S-Down>", ":m '>+1<CR>gv=gv", { noremap = false })
vim.keymap.set("v", "<M-S-Up>", ":m '<-2<CR>gv=gv", { noremap = false })
-- move a linha sendo editada
vim.keymap.set("i", "<M-S-Down>", "<esc>my:m 'y+1<CR>==gi", { noremap = false })
vim.keymap.set("i", "<M-S-Up>", "<esc>my:m 'y-2<CR>==gi", { noremap = false })
-- abrir split vertical igual uso no tmux
vim.keymap.set("n", "<leader>\\", ":vsplit<cr>", noremapsilent)

-- Bufferline remap
vim.keymap.set(
  "n",
  "<C-PageDown>",
  "<cmd>BufferLineCycleNext<CR>",
  { noremap = true, silent = true, desc = "Tabs cycle Next navigation}" }
)
vim.keymap.set(
  "n",
  "<C-PageUp>",
  "<cmd>BufferLineCyclePrev<CR>",
  { noremap = true, silent = true, desc = "Tabs cycle Prev navigation}" }
)

-- Apaga sem alterar os registros.
vim.keymap.set("n", "<leader>dd", '"_dd', extendAttributes(noremapsilent, { desc = "dd no yank" }))
vim.keymap.set("v", "<leader>d", '"_d', extendAttributes(noremapsilent, { desc = "d no yank" }))
vim.keymap.set("n", "<leader>xx", '"_x', extendAttributes(noremapsilent, { desc = "x no yank" }))
vim.keymap.set("v", "<leader>xx", '"_x', extendAttributes(noremapsilent, { desc = "x no yank" }))

-- Insert blank lines keeping the cursor position
vim.keymap.set(
  "n",
  "<leader>O",
  ':<c-u>call append(line(".")-1, repeat([""], v:count1))<cr>',
  extendAttributes(noremapsilent, { desc = "New line above" })
)
vim.keymap.set(
  "n",
  "<leader>o",
  ':<C-u>call append(line("."), repeat([""], v:count1))<CR>',
  extendAttributes(noremapsilent, { desc = "New line below" })
)

-- J melhorado. Mantém cursor na posição.
vim.keymap.set("n", "J", "mzJ`z")

-- Select All
vim.keymap.set("n", "<leader>A", "ggVG", extendAttributes(noremapsilent, { desc = "Select All" }))

-- My Git commit
vim.keymap.set("n", "<leader>gC", "", {
  desc = "Git commit input msg",
  noremap = true,
  silent = true,
  callback = function()
    vim.ui.input({ prompt = "Commit Message: " }, function(input)
      if input then
        vim.cmd('Git commit -m "' .. input .. '"')
      end
    end)
  end,
})
