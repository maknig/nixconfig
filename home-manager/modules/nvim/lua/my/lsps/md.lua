local M = {}

function M.setup(capabilities)
	vim.lsp.config("marksman", {
		on_attach = M.on_attach,
		capabilities = capabilities,
		settings = {
			marksman = {
				-- optional: configure marksman settings (see marksman docs)
				completion = { enable = true },
				frontmatter = { use = "preserve" },
			},
		},
	})

	vim.lsp.enable("marksman")
end

return M
