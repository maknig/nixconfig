local M = {}

function M.setup(capabilities)
	vim.lsp.config("basedpyright", {
		on_attach = require('my.lsp').on_attach,
		capabilities = capabilities,
		settings = {
			basedpyright = {
				-- NOTE consider
				-- pyright.disableLanguageServices if we want to use basedpyright?
				-- pyright.disableTaggedHints
				disableOrganizeImports = true,
				disableTaggedHints = false, -- graying out stuff or striking through
				analysis = {
					autoImportCompletions = true,
					-- TODO what marks a workspace?
					diagnosticMode = "workspace",
					useLibraryCodeForTypes = true,
					-- only basedpyright
					inlayHints = {
						-- TODO setting to false doesnt seem to change anything. wrong setting path?
						variableTypes = true,
						callArgumentNames = true,
						functionReturnTypes = true,
						genericTypes = true,
					},
				},
			},
		},
	})

	vim.lsp.enable("basedpyright")
end

return M
