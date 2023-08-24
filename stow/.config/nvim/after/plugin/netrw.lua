-- augroup netrw_mapping
--     autocmd!
--     autocmd filetype netrw call NetrwMapping()
-- augroup END
--
-- function! NetrwMapping()
--     noremap <buffer> i h
-- endfunction
-- v
-- 
local cmd = vim.cmd

-- Highlight on yank
cmd [[
  augroup netrw_mapping 
    autocmd!
    autocmd FileType netrw nmap <buffer> l <Enter>
    autocmd FileType netrw nmap <buffer> h -
  augroup end
]]
