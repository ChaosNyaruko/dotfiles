-- from scratch
require ("base")
require ("maps")
require ("plugins")

local has = function(x)
	return vim.fn.has(x) == 1
end

local has_clipboard = has "clipboard"
local has_unnamedplus = has "unnamedplus"

if has_clipboard then
	if has_unnamedplus then
		vim.opt.clipboard = {'unnamed', 'unnamedplus'}
	else
		vim.opt.clipboard = {'unnamed'}
	end
end
