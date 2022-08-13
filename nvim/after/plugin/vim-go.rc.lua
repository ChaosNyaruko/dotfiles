vim.g.go_list_type = 'quickfix'

vim.api.nvim_create_autocmd('FileType', { pattern = 'go', command = "noremap <buffer> gr :GoReferrers<cr>" })
vim.api.nvim_create_autocmd('FileType', { pattern = 'go', command = "noremap <buffer> gi :GoImplements<cr>" })
vim.api.nvim_create_autocmd('FileType', { pattern = 'go', command = "noremap <buffer> goc :GoCallers<cr>" })
