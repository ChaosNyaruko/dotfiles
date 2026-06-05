vim.cmd([[
function! CatSnippets(ArgLead, CmdLine, CursorPos)
    return [
    \ '#!/usr/bin/sh',
    \ 'function ${1:name}(${2:args}) $0 end',
    \ 'func ${1:name}(${2:args}) $0']
endfun
]])
local f = function()
    local s = vim.fn.input("input your snippet trigger:", "", "customlist,CatSnippets")
    vim.snippet.expand(s)
end
