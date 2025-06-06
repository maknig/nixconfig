local mod = {}

function mod.setup()
	local funky_formatter = require("funky-formatter")
	funky_formatter.setup({
		formatters = {
			python = { command = { "pyformat" } },
			--lua = { command = { 'stylua', '--config-path', '.stylua.toml', '-' } },
			lua = { command = { "stylua", "-" } },
			json = { command = { "jq" } },
			rust = { command = { "rustfmt" } },
			css = { command = { "prettier", "--parser", "css" } },
			graphql = { command = { "prettier", "--parser", "graphql" } },
			javascript = { command = { "prettier", "--parser", "typescript" } },
			markdown = { command = { "prettier", "--parser", "markdown" } },
			typescript = { command = { "prettier", "--parser", "typescript" } },
			typescriptreact = { command = { "prettier", "--parser", "typescript" } },
			yaml = { command = { "prettier", "--parser", "yaml" } },
			nix = { command = { "nixpkgs-fmt" } },
			cpp = { command = { "clang-format" } },
			proto = { command = { "clang-format" } },
			tex = { command = { "tex-fmt", "--stdin", "--quiet" } },
		},
	})
	vim.keymap.set("n", "==", funky_formatter.format, { desc = "funky formatter" })
end

return mod
