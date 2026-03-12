local M = {}

function M.setup(capabilities)
	require("ltex-utils").setup({
		backend = "ltex_plus",
	})

	vim.lsp.config("ltex_plus", {
		capabilities = capabilities,
		on_attach = function(client, bufnr)
			require("ltex-utils").on_attach(client, bufnr) -- attach ltex-utils handlers
		end,
		settings = {
			ltex = {
				enabled = { "latex", "tex", "markdown" },
				language = "de-CH",
			},
		},
	})
	-- vim.lsp.config("ltex_plus", {
	-- 	--cmd = { "ltex-ls-plus", "--server-type", "TcpSocket" }, -- ensure this is in your PATH
	-- 	cmd = { "ltex-ls-plus" }, -- ensure this is in your PATH
	-- 	filetypes = {
	-- 		"markdown",
	-- 		"tex",
	-- 		"bib",
	-- 		"plaintex",
	-- 	},
	-- 	settings = {
	-- 		ltex = {
	-- 			language = "auto", -- or "en-US", "de-DE", etc.
	--
	-- 			additionalRules = {
	-- 				enablePickyRules = true,
	-- 			},
	-- 		},
	-- 	},
	-- 	-- on_attach = function(client, bufnr)
	-- 	-- 	require("ltex-utils").on_attach(client, bufnr) -- attach ltex-utils handlers
	-- 	-- end,
	-- })

	vim.lsp.enable("ltex_plus")
end

return M
