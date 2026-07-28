local M = {}

function M.setup(capabilities)
	vim.lsp.config("clangd", {
		on_attach = require("my.lsp").on_attach,
		capabilities = capabilities,
	})

	vim.lsp.enable("clangd")
end

return M
