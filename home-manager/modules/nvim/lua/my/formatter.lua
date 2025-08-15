local M = {}

function M.setup()
	local formatter = require("conform")
	formatter.setup({
		formatters_by_ft = {
			lua = { "stylua" },
			-- Conform will run multiple formatters sequentially
			python = { "ruff_check", "ruff_format" },
			-- You can customize some of the format options for the filetype (:help conform.format)
			rust = { "rustfmt", lsp_format = "fallback" },
			-- Conform will run the first available formatter
			javascript = { "prettierd", "prettier", stop_after_first = true },
		},
	})

	vim.keymap.set("n", "==", formatter.format, { desc = "conform formatter" })
end

return M
