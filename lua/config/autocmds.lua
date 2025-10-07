-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- INFO: Fixes harpoon BUG
-- centering buffer/cursor position when switching
vim.cmd([[
" Save current view settings on a per-window, per-buffer basis.
function! AutoSaveWinView()
    if !exists("w:SavedBufView")
        let w:SavedBufView = {}
    endif
    let w:SavedBufView[bufnr("%")] = winsaveview()
endfunction

" Restore current view settings.
function! AutoRestoreWinView()
    let buf = bufnr("%")
    if exists("w:SavedBufView") && has_key(w:SavedBufView, buf)
        let v = winsaveview()
        let atStartOfFile = v.lnum == 1 && v.col == 0
        if atStartOfFile && !&diff
            call winrestview(w:SavedBufView[buf])
        endif
        unlet w:SavedBufView[buf]
    endif
endfunction

" When switching buffers, preserve window view.
if v:version >= 700
    autocmd BufLeave * call AutoSaveWinView()
    autocmd BufEnter * call AutoRestoreWinView()
endif
]])

-- Configuração para abrir arquivos .docx em mode readonly usando o docx2txt
vim.api.nvim_create_autocmd("BufReadPre", {
  pattern = "*.docx",
  callback = function()
    vim.opt_local.readonly = true
  end,
})
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*.docx",
  command = "%!docx2txt",
})

-- vim.api.nvim_create_autocmd("BufRead", {
--   pattern = "*.md",
--   callback = function()
--     vim.opt_local.foldmethod = "manual"
--     vim.cmd.normal("gg") -- garante que estamos no topo
--     vim.cmd([[silent! execute "g/^#### /normal! za"]])
--     vim.cmd([[silent! execute "g/^### /normal! za"]])
--     vim.cmd([[silent! execute "g/^## /normal! za"]])
--   end,
-- })
