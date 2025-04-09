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

vim.keymap.set("n", "<leader>tfx", ":!chmod +x %<CR>", { silent = true, desc = "Toggle File executable" })

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

-- yank/copy to end of line minus newline!
vim.keymap.set("n", "Y", "v$hy", { desc = "[P]Yank to end of line" })

-- Bufferline remap
vim.keymap.set(
  "n",
  "<C-PageDown>",
  "<cmd>bn<CR>",
  { noremap = true, silent = true, desc = "Buffers cycle Next navigation}" }
)
vim.keymap.set(
  "n",
  "<C-PageUp>",
  "<cmd>bp<CR>",
  { noremap = true, silent = true, desc = "Buffers cycle Prev navigation}" }
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

vim.keymap.set(
  "n",
  "<leader>mh",
  [[:%s/^\(#\+\)/#\1/<CR>|:0;/^## /s/^## /# /<CR>]],
  { noremap = true, silent = true, desc = "¹ Markdown FIX Headings" }
)

-- NOTE: New method of yanking text without LF (Line Feed) characters
-- This method is preferred because the old method requires a lot of edge cases,
-- for example codeblocks, or blockquotes which use `>`
--
-- Prettier is what autoformats all my files, including the markdown files
-- proseWrap: "always" is only enabled for markdown, which wraps all my markdown
-- lines at 80 characters, even existing lines are autoformatted
--
-- So only for markdown files, I'm copying all the text, to a temp file, applying
-- the prettier --prose-wrap never --write command on that file, then copying
-- the text in that file to my system clipboard
--
-- This gives me text without LF characters that I can pate in slack, the
-- browser, etc
vim.keymap.set("v", "y", function()
  -- Check if the current buffer's filetype is markdown
  if vim.bo.filetype ~= "markdown" then
    -- Not a Markdown file, copy the selection to the system clipboard
    vim.cmd('normal! "+y')
    -- Optionally, notify the user
    vim.notify("Yanked to system clipboard", vim.log.levels.INFO)
    return
  end
  -- Yank the selected text into register 'z' without affecting the unnamed register
  vim.cmd('silent! normal! "zy')
  -- Get the yanked text from register 'z'
  local text = vim.fn.getreg("z")
  -- Path to a temporary file (uses a unique temporary file name)
  local temp_file = vim.fn.tempname() .. ".md"
  -- Write the selected text to the temporary file
  local file = io.open(temp_file, "w")
  if file == nil then
    vim.notify("Error: Cannot write to temporary file.", vim.log.levels.ERROR)
    return
  end
  file:write(text)
  file:close()
  -- Run Prettier on the temporary file to format it
  local cmd = 'prettier --prose-wrap never --write "' .. temp_file .. '"'
  local result = os.execute(cmd)
  if result ~= 0 then
    vim.notify("Error: Prettier formatting failed.", vim.log.levels.ERROR)
    os.remove(temp_file)
    return
  end
  -- Read the formatted text from the temporary file
  file = io.open(temp_file, "r")
  if file == nil then
    vim.notify("Error: Cannot read from temporary file.", vim.log.levels.ERROR)
    os.remove(temp_file)
    return
  end
  local formatted_text = file:read("*all")
  file:close()
  -- Copy the formatted text to the system clipboard
  vim.fn.setreg("+", formatted_text)
  -- Delete the temporary file
  os.remove(temp_file)
  -- Notify the user
  vim.notify("yanked markdown with --prose-wrap never", vim.log.levels.INFO)
end, { desc = "[P]Copy selection formatted with Prettier", noremap = true, silent = true })

-- NOTE: Spell mappings
-- Keymap to switch spelling language to English lamw25wmal
-- To save the language settings configured on each buffer, you need to add
-- "localoptions" to vim.opt.sessionoptions in the `lua/config/options.lua` file
vim.keymap.set("n", "<leader>msle", function()
  vim.opt.spelllang = "en"
  vim.cmd("echo 'Spell language set to English'")
end, { desc = "[P]Spelling language English" })

-- Keymap to switch spelling language to Spanish lamw25wmal
vim.keymap.set("n", "<leader>mslp", function()
  vim.opt.spelllang = "pt"
  vim.cmd("echo 'Spell language set to Portuguese'")
end, { desc = "[P]Spelling language Portuguese" })

-- Keymap to switch spelling language to Spanish lamw25wmal
vim.keymap.set("n", "<leader>msls", function()
  vim.opt.spelllang = "es"
  vim.cmd("echo 'Spell language set to Spanish'")
end, { desc = "[P]Spelling language Spanish" })

-- Keymap to switch spelling language to both spanish and english lamw25wmal
vim.keymap.set("n", "<leader>mslb", function()
  vim.opt.spelllang = "en,pt"
  vim.cmd("echo 'Spell language set to Portuguese and English'")
end, { desc = "[P]Spelling language Portuguese and English" })
