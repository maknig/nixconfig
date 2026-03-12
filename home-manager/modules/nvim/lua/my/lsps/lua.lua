local M = {}

function M.setup(capabilities)
	vim.lsp.config("lua_ls", {
		on_attach = require("my.lsp").on_attach,
		capabilities = capabilities,
	})

	vim.lsp.enable("lua_ls")
end

return M
