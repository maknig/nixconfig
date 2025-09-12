local M = {}

local function map(mode, lhs, rhs, desc, opts)
	local options = { silent = true, noremap = true }
	if desc then
		options.desc = desc
	end
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.keymap.set(mode, lhs, rhs, options)
end

-- Shorthand helpers for common modes
local function nmap(lhs, rhs, desc, opts)
	map("n", lhs, rhs, desc, opts)
end

local function vmap(lhs, rhs, desc, opts)
	map("v", lhs, rhs, desc, opts)
end

local function imap(lhs, rhs, desc, opts)
	map("i", lhs, rhs, desc, opts)
end

local function tmap(lhs, rhs, desc, opts)
	map("t", lhs, rhs, desc, opts)
end

function M.setup()
	M.general()
	M.diagnostic()
	M.tabs()
	M.git()
end

function M.diagnostic()
	local D = vim.diagnostic

	nmap("ts", D.open_float, "diagnostics float")

	nmap("tk", function()
		D.goto_prev()
		vim.cmd("normal! zz")
	end, "diagnostics previous")
	nmap("th", function()
		D.goto_next()
		vim.cmd("normal! zz")
	end, "diagnostics next")
	nmap("tK", D.setqflist, "diagnostics global qflist")
	nmap("tH", D.setloclist, "diagnostics buffer loclist")
end

function M.tabs()
	map("", "tt", ":tab split<enter>", "tab split")
	map("", "tT", "<c-w>T", "")
	map("", "tc", ":tabclose<enter>", "tab close")
	map("", "tp", ":tabprevious<enter>", "tab previous")
	map("", "tn", ":tabnext<enter>", "tab next")
	map("", "to", ":tabonly<enter>", "tab only")
end

function M.git()
	map("n", ",gs", ":tab Git<enter>")
	map("n", ",gci", ":Git commit<enter>")
	map("n", ",gd", ":Git diff<cr>")
	map("n", ",gl", ":Gclog<cr>")
end

function M.general()
	map("", ";", ":", "", { silent = false })

	map("i", "jj", "<Esc>", "no esc to leave insert")
	map("", "gp", "`[v`]", "select last pasted lines") -- select last pasted lines

	map("", "//", ":nohlsearch<enter>", "reset search") -- reset search

	-- search for selected text
	-- xnoremap({ "*", '"xy/<c-r><cr>' })

	-- quickfix
	-- map('', 'cj', ':cprev<cr>', {})
	-- map('', 'ck', ':cnext<cr>', {})

	vim.keymap.set("n", "<leader>mr", require("micropython_nvim").run)

	-- Search results centered please
	-- map('', 'n', 'nzz', {})
	-- map('', 'N', 'Nzz', {})
	-- map('', '*', '*zz', {})
	-- map('', '#', '#zz', {})
	-- map('', 'g*', 'g*zz', {})
end

return M
