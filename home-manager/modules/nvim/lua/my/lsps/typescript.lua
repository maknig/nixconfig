local M = {}

function M.setup(capabilities)
	vim.lsp.config("ts_ls", {
		capabilities = capabilities,
		on_attach = require('my.lsp').on_attach,
	})

	vim.lsp.enable("biome")
	vim.lsp.enable("ts_ls")
end

return M
