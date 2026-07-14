local M = {}

-- from looking at
--   nvim/runtime/lua/vim/lsp/buf.lua
--   nvim/runtime/lua/vim/lsp/handlers.lua
--   nvim/runtime/lua/vim/lsp/util.lua
-- all the lsp jumps are done async, but I need it sync
-- and there is no option to control this
-- I want: sync, optional splits or tabs before, move target line to the top (like "zt")
--
function M.get_one_lsp_client()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if #clients == 0 then
		vim.cmd.echomsg([["no lsp on this buffer"]])
		return nil
	elseif #clients == 1 then
		return clients[1]
	else
		vim.cmd.echomsg([["more than one lsp on this buffer"]])
		return clients[1]
	end
end

function M.op(method)
	local function fn(make)
		local client = M.get_one_lsp_client()
		if not client then
			return
		end

		local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
		local replies, error = client:request_sync(method, params, 2000, 0)

		if error or not replies or replies.err then
			vim.print({ replies = replies, error = error })
			vim.cmd.echomsg([["lsp error"]])
			return
		end

		if not replies.result or #replies.result == 0 then
			vim.cmd.echomsg([["no candidates"]])
			return
		end

		if #replies.result > 1 then
			local builtin = require("telescope.builtin")
			builtin.lsp_definitions()
			return
		end

		local selected = replies.result[1]

		make()
		vim.lsp.util.show_document(selected, client.offset_encoding)
		vim.cmd("normal! zt")
	end
	return fn
end

local function lsp_jumper(method, before)
	-- methods
	--   textDocument/definition
	return function()
		local clients = vim.lsp.get_clients({ bufnr = 0 })
		if #clients == 0 then
			vim.notify("no lsp on this buffer")
			return
		end
		local client = clients[1]

		local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
		local reply, err = client:request_sync(method, params, 2000, 0)

		if err or not reply or reply.err then
			vim.notify("lsp error: " .. (err or vim.inspect(reply and reply.err)))
			return
		end

		if not reply.result or #reply.result == 0 then
			vim.notify("no candidates")
			return
		end

		if #reply.result > 1 then
			require("telescope.builtin").lsp_definitions()
			return
		end

		local selected = reply.result[1]
		if before then
			vim.cmd(before)
		end
		vim.lsp.util.show_document(selected, client.offset_encoding, { focus = true })
		vim.cmd("normal! zt")
	end
end

function M.setup()
	local capabilities = require("cmp_nvim_lsp").default_capabilities()

	M.setup_luasnip()

	M.setup_completion()
	--require("my.lsps.rust").setup_rustaceanvim(capabilities)
	require("my.lsps.clangd").setup(capabilities)
	require("my.lsps.lua").setup(capabilities)
	require("my.lsps.nix").setup(capabilities)
	require("my.lsps.python").setup(capabilities)
	-- require("my.lsps.ltex").setup(capabilities)
	require("my.lsps.rust").setup(capabilities)
	require("my.lsps.typescript").setup(capabilities)
	require("my.lsps.yaml").setup(capabilities)
end

function M.setup_luasnip()
	-- see https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md
	local ls = require("luasnip")
	local s = ls.snippet
	local t = ls.text_node
	ls.add_snippets("all", { s("!class", { t("class") }) })
end

function M.setup_completion()
	local cmp = require("cmp")

	cmp.setup({
		view = { entries = { name = "wildmenu", separator = " | " }, docs = { auto_open = true } },
		--view = { entries = { name = "menuone", separator = " | " }, docs = { auto_open = true } },
		--completion = {
		--	autocomplete = true,
		--	--completeopt = "menu,menuone",
		--},
		snippet = {
			expand = function(args)
				require("luasnip").lsp_expand(args.body)
			end,
		},
		mapping = {
			["<c-t>"] = cmp.mapping(
				cmp.mapping.complete({
					reason = cmp.ContextReason.Auto,
				}),
				{ "i", "c" }
			),
			["<enter>"] = cmp.mapping.confirm({ select = true }),
			["<c-j>"] = cmp.mapping.select_next_item(),
			["<c-k>"] = cmp.mapping.select_prev_item(),
			["<Tab>"] = cmp.mapping({
				i = function(fallback)
					if cmp.visible() then
						cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
					else
						fallback()
					end
				end,
			}),
			["<S-Tab>"] = cmp.mapping({

				i = function(fallback)
					if cmp.visible() then
						cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
					else
						fallback()
					end
				end,
			}),
			-- ['<c-u>'] = cmp.mapping.open_docs(),
		},
		experimental = {
			ghost_text = true,
		},
		sources = cmp.config.sources({
			{ name = "nvim_lsp" },
			{ name = "nvim_lua" },
			{ name = "spell" },
			{ name = "luasnip" },
		}),
		formatting = {
			format = require("lspkind").cmp_format({
				mode = "symbol_text",
				maxwidth = 50,
				menu = {
					buffer = "[buffer]",
					nvim_lsp = "[lsp]",
					nvim_lua = "[lua]",
				},
			}),
		},
	})

	-- enable completing paths in :
	cmp.setup.cmdline(":", {
		sources = cmp.config.sources({
			{ name = "path" },
		}),
	})
end

function M.definition()
	vim.cmd("vsplit")
	vim.lsp.buf.definition()
end

function M.on_attach(client, bufnr)
	vim.api.nvim_set_option_value("signcolumn", "yes", {})

	local function nmap(lhs, rhs, desc)
		vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
	end
	local function imap(lhs, rhs, desc)
		vim.keymap.set("i", lhs, rhs, { buffer = bufnr, desc = desc })
	end

	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local b = vim.lsp.buf

	nmap("gD", b.declaration)
	-- nmap("gi", b.implementation)
	nmap("gtd", b.type_definition)

	nmap("gi", lsp_jumper("textDocument/implementation"), "go to implementation")

	nmap("gd", lsp_jumper("textDocument/definition"), "go to definition")
	nmap("gdt", lsp_jumper("textDocument/definition", "tab split"), "go to definition in a new tab")
	nmap(
		"gdr",
		lsp_jumper("textDocument/definition", "set splitright | vsplit | set splitright!"),
		"go to definition in split right"
	)
	nmap("gdl", lsp_jumper("textDocument/definition", "vsplit"), "go to definition in split left")
	nmap("gdd", lsp_jumper("textDocument/definition", "split"), "go to definition in split down")
	nmap(
		"gdu",
		lsp_jumper("textDocument/definition", "set splitbelow! | split | set splitbelow!"),
		"go to definition in split up"
	)

	nmap("K", b.hover, "hover symbol")
	imap("<c-k>", b.signature_help, "signature help")
	nmap("tl", b.references, "find references")
	nmap("ca", b.code_action, "code action")
	nmap("rn", b.rename, "rename symbol")

	-- See `:help vim.diagnostic.*` for documentation on any of the below functions
	-- get signatures (and _only_ signatures) when in argument lists
	require("lsp_signature").on_attach({
		doc_lines = 0,
		handler_opts = {
			border = "none",
		},
	})
end

function M.setup_python(capabilities)
	-- vim.lsp.config("ty", {
	-- 	capabilities = capabilities,
	-- 	inlayHints = {
	-- 		variableTypes = true,
	-- 		callArgumentNames = true,
	-- 	},
	-- 	experimental = {
	-- 		rename = true,
	-- 	},
	-- 	settings = {
	-- 		ty = {
	-- 			diagnosticMode = "workspace",
	-- 		},
	-- 	},
	-- })
	vim.lsp.config("ty", {
		capabilities = capabilities,
		settings = {
			ty = {
				inlayHints = {
					callArgumentNames = true,
					variableTypes = true,
				},
				experimental = {
					rename = true,
				},

				diagnosticMode = "workspace",
			},
		},
	})

	-- Required: Enable the language server
	vim.lsp.enable("ty")
end

function M.setup_tex(capabilities)
	vim.lsp.config("texlab", {
		capabilities = capabilities,
	})

	vim.lsp.enable("texlab")
end

return M
