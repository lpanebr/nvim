-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.python3_host_prog = vim.fn.expand("~/.pyenv/versions/neovim3/bin/python")

vim.g.git_worktree = {
  change_directory_command = "cd",
  update_on_change = true,
  update_on_change_command = "e .",
  clearjumps_on_change = true,
  confirm_telescope_deletions = true,
  autopush = false,
}

-- Shows colorcolumn that helps me with markdown guidelines. This applies to ALL
-- file types
vim.opt.colorcolumn = "80"

-- -- To apply it to markdown files only
-- vim.api.nvim_create_autocmd("BufWinEnter", {
--   pattern = { "*.md" },
--   callback = function()
--     vim.opt.colorcolumn = "80"
--     vim.opt.textwidth = 80
--   end,
-- })

-- I added `localoptions` to save the language spell settings, otherwise, the
-- language of my markdown documents was not remembered if I set it to spanish
-- or to both en,es
-- See the help for `sessionoptions`
-- `localoptions`: options and mappings local to a window or buffer
-- (not global values for local options)
--
-- The plugin that saves the session information is
-- https://github.com/folke/persistence.nvim and comes enabled in the
-- lazyvim.org distro lamw25wmal
--
-- These sessionoptions come from the lazyvim distro, I just added localoptions
-- https://www.lazyvim.org/configuration/general
vim.opt.sessionoptions = {
  "buffers",
  "curdir",
  "tabpages",
  "winsize",
  "help",
  "globals",
  "skiprtp",
  "folds",
  "localoptions",
}

-- INFO: WinBar with total open files and current buffer filename
-- by linkarzu: https://github.com/linkarzu/dotfiles-latest/blob/main/neovim/neobean/lua/config/options.lua
vim.cmd(string.format([[highlight WinBar1 guifg=%s]], "#00aaff"))
vim.cmd(string.format([[highlight WinBar2 guifg=%s]], "#ffcc00"))
-- Function to get the full path and replace the home directory with ~
local function get_winbar_path()
  local full_path = vim.fn.expand("%:p")
  return full_path:gsub(vim.fn.expand("$HOME"), "~")
end
-- Function to get the number of open buffers using the :ls command
local function get_buffer_count()
  local buffers = vim.fn.execute("ls")
  local count = 0
  -- Match only lines that represent buffers, typically starting with a number followed by a space
  for line in string.gmatch(buffers, "[^\r\n]+") do
    if string.match(line, "^%s*%d+") then
      count = count + 1
    end
  end
  return count
end
-- Function to update the winbar
local function update_winbar()
  local home_replaced = get_winbar_path()
  local buffer_count = get_buffer_count()
  vim.opt.winbar = "%#WinBar1#%m "
    .. "%#WinBar2#("
    .. buffer_count
    .. ") "
    .. "%#WinBar1#"
    .. home_replaced
    .. "%*%=%#WinBar2#"
    .. vim.fn.systemlist("hostname")[1]
end
-- Autocmd to update the winbar on BufEnter and WinEnter events
vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
  callback = update_winbar,
})

-- ############################################################################
--                         Begin of markdown section
-- ############################################################################

-- Mappings for creating new groups that don't exist
-- When I press leader, I want to modify the name of the options shown
-- "m" is for "markdown" and "t" is for "todo"
-- https://github.com/folke/which-key.nvim?tab=readme-ov-file#%EF%B8%8F-mappings
-- local wk = require("which-key")
-- wk.add({
--   {
--     mode = { "n" },
--     { "<leader>t", group = "¹ todo" },
--   },
--   {
--     mode = { "n", "v" },
--     { "<leader>m", group = "¹ markdown" },
--     { "<leader>mf", group = "¹ fold" },
--     { "<leader>mh", group = "¹ headings increase/decrease" },
--     { "<leader>ml", group = "¹ links" },
--     { "<leader>ms", group = "¹ spell" },
--     { "<leader>msl", group = "¹ language" },
--   },
-- })

-- Delete empty lines
-- Modified from linkarzu
vim.keymap.set("v", "<leader>mj", ":g/^$/d<cr>:noh<cr>", { desc = "¹ Delete empty lines in selected text (join)" })

-- Remove bullets and paragraph marks.a
vim.keymap.set("n", "<leader>mcs0", [[:.s/^\W*\s*//<cr>:noh<cr>]], { desc = "¹ Remove bullets and paragraph marks." })

-- INFO: Lua regex:
-- Caracteres especiais como . ( ) * + - ? [ ] precisam ser escapados com %
-- quando usados como literais dentro de expressões regulares em funções como
-- match ou gsub

-- Função que remove formatações de bullet, numeração e checklists
local function lgp_clear_list_format(line)
  local indent = line:match("^(%s*)") -- Captura os espaços iniciais
  -- Remove checklists, ex.: "- [ ] " ou "- [x] "
  line = line:gsub("^%s*[-*+]%s*%[[xX%s]?%]%s*", "", 1)
  -- Remove listas numeradas, ex.: "1. " ou "2) "
  line = line:gsub("^%s*%d+[%.)]%s*", "", 1)
  -- Remove listas numeradas, ex.: "i. " ou "I) "
  line = line:gsub("^%s*[IVLCivlc]+[%.)]%s*", "", 1)
  -- Remove listas numeradas, ex.: "a. " ou "I) "
  line = line:gsub("^%s*[a-zA-Z]+[%.)]%s*", "", 1)
  -- Remove bullets simples, ex.: "- ", "* ", "+ "
  line = line:gsub("^%s*[-*+]%s+", "", 1)
  return indent, line
end
-- Verifica se a linha é um checklist, ex.: "- [ ] item" ou "- [x] item"
local function lgp_is_checklist(line)
  return line:match("^%s*[-*+]%s*%[[xX%s]?%]%s+") ~= nil
end
-- Verifica se a linha é uma lista numerada, ex.: "1. item" ou "2) item"
local function lgp_is_numbered(line)
  return line:match("^%s*%d+[%.)]%s+") ~= nil
end
-- Verifica se a linha é uma lista com bullet simples, ex.: "- item"
-- Garante que não seja um checklist
local function lgp_is_bullet(line)
  return (line:match("^%s*[-*+]%s+") ~= nil) and not lgp_is_checklist(line)
end
-- Não é uma lista
local function lgp_is_plain(line)
  return not (lgp_is_checklist(line) or lgp_is_numbered(line) or lgp_is_bullet(line))
end
-- É uma lista
local function lgp_is_list(line)
  return (lgp_is_checklist(line) or lgp_is_numbered(line) or lgp_is_bullet(line))
end

-- Set Numbered list: My Ctrl Shift 7
vim.keymap.set({ "n", "v" }, "<leader>mcs7", function()
  local buf = vim.api.nvim_get_current_buf()
  local mode = vim.fn.mode()
  local start_line, end_line
  -- Se estiver em modo visual, obtém a seleção
  if mode:match("[vV\22]") then
    start_line = vim.fn.line("'<") - 1
    end_line = vim.fn.line("'>")
  else
    local pos = vim.api.nvim_win_get_cursor(0)
    start_line = pos[1] - 1
    end_line = pos[1]
  end
  local lines = vim.api.nvim_buf_get_lines(buf, start_line, end_line, false)
  for i, line in ipairs(lines) do
    local is_numbered = lgp_is_numbered(line)
    local indent, clean_line = lgp_clear_list_format(line)
    if is_numbered then
      lines[i] = indent .. clean_line
    else
      lines[i] = indent .. "1. " .. clean_line
    end
  end
  vim.api.nvim_buf_set_lines(buf, start_line, end_line, false, lines)
end, { desc = "¹ Toggle Numbered list." })

-- Set Bullet list: My Ctrl Shift 8
vim.keymap.set({ "n", "v" }, "<leader>mcs8", function()
  local buf = vim.api.nvim_get_current_buf()
  local mode = vim.fn.mode()
  local start_line, end_line
  -- Se estiver em modo visual, obtém a seleção
  if mode:match("[vV\22]") then
    start_line = vim.fn.line("'<") - 1
    end_line = vim.fn.line("'>")
  else
    local pos = vim.api.nvim_win_get_cursor(0)
    start_line = pos[1] - 1
    end_line = pos[1]
  end
  local lines = vim.api.nvim_buf_get_lines(buf, start_line, end_line, false)
  for i, line in ipairs(lines) do
    local is_bullet = lgp_is_bullet(line)
    local indent, clean_line = lgp_clear_list_format(line)
    if is_bullet then
      lines[i] = indent .. clean_line
    else
      lines[i] = indent .. "- " .. clean_line
    end
  end
  vim.api.nvim_buf_set_lines(buf, start_line, end_line, false, lines)
end, { desc = "¹ Toggle Bullet list." })

-- Set Check list: My Ctrl Shift 9
vim.keymap.set({ "n", "v" }, "<leader>mcs9", function()
  local buf = vim.api.nvim_get_current_buf()
  local mode = vim.fn.mode()
  local start_line, end_line
  -- Se estiver em modo visual, obtém a seleção
  if mode:match("[vV\22]") then
    start_line = vim.fn.line("'<") - 1
    end_line = vim.fn.line("'>")
  else
    local pos = vim.api.nvim_win_get_cursor(0)
    start_line = pos[1] - 1
    end_line = pos[1]
  end
  local lines = vim.api.nvim_buf_get_lines(buf, start_line, end_line, false)
  for i, line in ipairs(lines) do
    local is_checklist = lgp_is_checklist(line)
    local indent, clean_line = lgp_clear_list_format(line)
    if is_checklist then
      lines[i] = indent .. clean_line
    elseif lgp_is_list(line) or lgp_is_plain(line) then
      lines[i] = indent .. "- [ ] " .. clean_line
    end
  end
  vim.api.nvim_buf_set_lines(buf, start_line, end_line, false, lines)
end, { desc = "¹ Set as Check list." })

-- Keymap to switch spelling language to English lamw25wmal
-- To save the language settings configured on each buffer, you need to add
-- "localoptions" to vim.opt.sessionoptions in the `lua/config/options.lua` file
vim.keymap.set("n", "<leader>msle", function()
  vim.opt.spelllang = "en"
  vim.cmd("echo 'Spell language set to English'")
end, { desc = "¹ Spelling language English" })

-- Keymap to switch spelling language to Spanish lamw25wmal
vim.keymap.set("n", "<leader>msls", function()
  vim.opt.spelllang = "es"
  vim.cmd("echo 'Spell language set to Spanish'")
end, { desc = "¹ Spelling language Spanish" })

-- Keymap to switch spelling language to both spanish and english lamw25wmal
vim.keymap.set("n", "<leader>mslb", function()
  vim.opt.spelllang = "en,es"
  vim.cmd("echo 'Spell language set to Spanish and English'")
end, { desc = "¹ Spelling language Spanish and English" })

-- Show spelling suggestions / spell suggestions
vim.keymap.set("n", "<leader>mss", function()
  -- Simulate pressing "z=" with "m" option using feedkeys
  -- vim.api.nvim_replace_termcodes ensures "z=" is correctly interpreted
  -- 'm' is the {mode}, which in this case is 'Remap keys'. This is default.
  -- If {mode} is absent, keys are remapped.
  --
  -- I tried this keymap as usually with
  vim.cmd("normal! 1z=")
  -- But didn't work, only with nvim_feedkeys
  -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("z=", true, false, true), "m", true)
end, { desc = "¹ Spelling suggestions" })

-- markdown good, accept spell suggestion
-- Add word under the cursor as a good word
vim.keymap.set("n", "<leader>msg", function()
  vim.cmd("normal! zg")
end, { desc = "¹ Spelling add word to spellfile" })

-- Undo zw, remove the word from the entry in 'spellfile'.
vim.keymap.set("n", "<leader>msu", function()
  vim.cmd("normal! zug")
end, { desc = "¹ Spelling undo, remove word from list" })

-- Repeat the replacement done by |z=| for all matches with the replaced word
-- in the current window.
vim.keymap.set("n", "<leader>msr", function()
  -- vim.cmd(":spellr")
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":spellr\n", true, false, true), "m", true)
end, { desc = "¹ Spelling repeat" })

-- In visual mode, check if the selected text is already bold and show a message if it is
-- If not, surround it with double asterisks for bold
vim.keymap.set("v", "<leader>mb", function()
  -- Get the selected text range
  local start_row, start_col = unpack(vim.fn.getpos("'<"), 2, 3)
  local end_row, end_col = unpack(vim.fn.getpos("'>"), 2, 3)
  -- Get the selected lines
  local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)
  local selected_text = table.concat(lines, "\n"):sub(start_col, #lines == 1 and end_col or -1)
  if selected_text:match("^%*%*.*%*%*$") then
    vim.notify("Text already bold", vim.log.levels.INFO)
  else
    vim.cmd("normal 2gsa*")
  end
end, { desc = "¹ BOLD current selection" })

-- -- Multiline unbold attempt
-- -- In normal mode, bold the current word under the cursor
-- -- If already bold, it will unbold the word under the cursor
-- -- If you're in a multiline bold, it will unbold it only if you're on the
-- -- first line
vim.keymap.set("n", "<leader>mb", function()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local current_buffer = vim.api.nvim_get_current_buf()
  local start_row = cursor_pos[1] - 1
  local col = cursor_pos[2]
  -- Get the current line
  local line = vim.api.nvim_buf_get_lines(current_buffer, start_row, start_row + 1, false)[1]
  -- Check if the cursor is on an asterisk
  if line:sub(col + 1, col + 1):match("%*") then
    vim.notify("Cursor is on an asterisk, run inside the bold text", vim.log.levels.WARN)
    return
  end
  -- Search for '**' to the left of the cursor position
  local left_text = line:sub(1, col)
  local bold_start = left_text:reverse():find("%*%*")
  if bold_start then
    bold_start = col - bold_start
  end
  -- Search for '**' to the right of the cursor position and in following lines
  local right_text = line:sub(col + 1)
  local bold_end = right_text:find("%*%*")
  local end_row = start_row
  while not bold_end and end_row < vim.api.nvim_buf_line_count(current_buffer) - 1 do
    end_row = end_row + 1
    local next_line = vim.api.nvim_buf_get_lines(current_buffer, end_row, end_row + 1, false)[1]
    if next_line == "" then
      break
    end
    right_text = right_text .. "\n" .. next_line
    bold_end = right_text:find("%*%*")
  end
  if bold_end then
    bold_end = col + bold_end
  end
  -- Remove '**' markers if found, otherwise bold the word
  if bold_start and bold_end then
    -- Extract lines
    local text_lines = vim.api.nvim_buf_get_lines(current_buffer, start_row, end_row + 1, false)
    local text = table.concat(text_lines, "\n")
    -- Calculate positions to correctly remove '**'
    -- vim.notify("bold_start: " .. bold_start .. ", bold_end: " .. bold_end)
    local new_text = text:sub(1, bold_start - 1) .. text:sub(bold_start + 2, bold_end - 1) .. text:sub(bold_end + 2)
    local new_lines = vim.split(new_text, "\n")
    -- Set new lines in buffer
    vim.api.nvim_buf_set_lines(current_buffer, start_row, end_row + 1, false, new_lines)
    -- vim.notify("Unbolded text", vim.log.levels.INFO)
  else
    -- Bold the word at the cursor position if no bold markers are found
    local before = line:sub(1, col)
    local after = line:sub(col + 1)
    local inside_surround = before:match("%*%*[^%*]*$") and after:match("^[^%*]*%*%*")
    if inside_surround then
      vim.cmd("normal gsd*.")
    else
      vim.cmd("normal viw")
      vim.cmd("normal 2gsa*")
    end
    vim.notify("Bolded current word", vim.log.levels.INFO)
  end
end, { desc = "¹ BOLD toggle bold markers" })

-- -- Single word/line bold
-- -- In normal mode, bold the current word under the cursor
-- -- If already bold, it will unbold the word under the cursor
-- -- This does NOT unbold multilines
-- vim.keymap.set("n", "<leader>mb", function()
--   local cursor_pos = vim.api.nvim_win_get_cursor(0)
--   -- local row = cursor_pos[1] -- Removed the unused variable
--   local col = cursor_pos[2]
--   local line = vim.api.nvim_get_current_line()
--   -- Check if the cursor is on an asterisk
--   if line:sub(col + 1, col + 1):match("%*") then
--     vim.notify("Cursor is on an asterisk, run inside the bold text", vim.log.levels.WARN)
--     return
--   end
--   -- Check if the cursor is inside surrounded text
--   local before = line:sub(1, col)
--   local after = line:sub(col + 1)
--   local inside_surround = before:match("%*%*[^%*]*$") and after:match("^[^%*]*%*%*")
--   if inside_surround then
--     vim.cmd("normal gsd*.")
--   else
--     vim.cmd("normal viw")
--     vim.cmd("normal 2gsa*")
--   end
-- end, { desc = "¹ BOLD toggle on current word or selection" })

-- In visual mode, surround the selected text with markdown link syntax
vim.keymap.set("v", "<leader>mll", function()
  -- Copy what's currently in my clipboard to the register "a lamw25wmal
  vim.cmd("let @a = getreg('+')")
  -- delete selected text
  vim.cmd("normal d")
  -- Insert the following in insert mode
  vim.cmd("startinsert")
  vim.api.nvim_put({ "[]() " }, "c", true, true)
  -- Move to the left, paste, and then move to the right
  vim.cmd("normal F[pf(")
  -- Copy what's on the "a register back to the clipboard
  vim.cmd("call setreg('+', @a)")
  -- Paste what's on the clipboard
  vim.cmd("normal p")
  -- Leave me in normal mode or command mode
  vim.cmd("stopinsert")
  -- Leave me in insert mode to start typing
  -- vim.cmd("startinsert")
end, { desc = "¹ Convert to link" })

-- In visual mode, surround the selected text with markdown link syntax
vim.keymap.set("v", "<leader>mlt", function()
  -- Copy what's currently in my clipboard to the register "a lamw25wmal
  vim.cmd("let @a = getreg('+')")
  -- delete selected text
  vim.cmd("normal d")
  -- Insert the following in insert mode
  vim.cmd("startinsert")
  vim.api.nvim_put({ '[](){:target="_blank"} ' }, "c", true, true)
  vim.cmd("normal F[pf(")
  -- Copy what's on the "a register back to the clipboard
  vim.cmd("call setreg('+', @a)")
  -- Paste what's on the clipboard
  vim.cmd("normal p")
  -- Leave me in normal mode or command mode
  vim.cmd("stopinsert")
  -- Leave me in insert mode to start typing
  -- vim.cmd("startinsert")
end, { desc = "¹ Convert to link (new tab)" })

-- Paste a github link and add it in this format
-- [folke/noice.nvim](https://github.com/folke/noice.nvim){:target="\_blank"}
vim.keymap.set("i", "<C-g>", function()
  -- Insert the text in the desired format
  vim.cmd('normal! a[](){:target="_blank"} ')
  vim.cmd("normal! F(pv2F/lyF[p")
  -- Leave me in normal mode or command mode
  vim.cmd("stopinsert")
end, { desc = "¹ Paste Github link" })

-- -- The following are related to indentation with tab, may not work perfectly
-- -- but get the job done
-- -- To indent in insert mode use C-T and C-D and in normal mode >> and <<
-- --
-- -- I disabled these as they interfere when jumpting to different sections of
-- -- my snippets, and probably other stuff, not a good idea
-- -- Maybe look for a different key, but not tab
-- --
-- -- Increase indent with tab in normal mode
-- vim.keymap.set("n", "<Tab>", function()
--   vim.cmd("normal >>")
-- end, { desc = "¹ Increase Indent" })
--
-- -- Decrease indent with tab in normal mode
-- vim.keymap.set("n", "<S-Tab>", function()
--   vim.cmd("normal <<")
-- end, { desc = "¹ Decrease Indent" })
--
-- -- Increase indent with tab in insert mode
-- vim.keymap.set("i", "<Tab>", function()
--   vim.api.nvim_input("<C-T>")
-- end, { desc = "¹ Increase Indent" })
--
-- -- Decrease indent with tab in insert mode
-- vim.keymap.set("i", "<S-Tab>", function()
--   vim.api.nvim_input("<C-D>")
-- end, { desc = "¹ Decrease Indent" })
