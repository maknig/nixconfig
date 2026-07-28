local M = {}

function M.setup_rustaceanvim(capabilities)
	local function on_attach(client, bufnr)
		require("my.lsp").on_attach(client, bufnr)
		local function nmap(lhs, rhs, desc)
			vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
		end
		nmap("td", ":RustLsp openDocs<CR>", "go to docs")
	end

	vim.g.rustaceanvim = {
		server = {
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				["rust-analyzer"] = {
					cargo = {
						allFeatures = true,
					},
					check = {
						command = "clippy",
					},
					diagnostics = {
						enable = true,
						experimental = {
							enable = true,
						},
					},
				},
			},
		},
	}
end

return M
