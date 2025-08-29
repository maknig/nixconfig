local M = {}

--function M.setup()
--	local formatter = require("conform")
--	formatter.setup({
--		formatters_by_ft = {
--			lua = { "stylua" },
--			-- Conform will run multiple fonirmatters sequentially
--			python = { "ruff_check", "ruff_format" },
--			-- You can customize some of the format options for the filetype (:help conform.format)
--			rust = { "rustfmt", lsp_format = "fallback" },
--			-- Conform will run the first available formatter
--			javascript = { "prettierd", "prettier", stop_after_first = true },
--		},
--	})
--	formatter.formatters.ruff_check = {
--	    inherit =  false,
--	    command = "ruff",
--	    args = { "check", "--fix-only", "--select", "I", "--silent" }
--
--	}
--
--	vim.keymap.set("n", "==", formatter.format, { desc = "conform formatter" })
--end
--
function M.setup()
	local formatter = require("formatter")

	formatter.setup({
		logging = true,
		log_level = vim.log.levels.WARN,

		filetype = {
			python = {
				function()
					return {
						exe = "ruff",
						args = { "check", "--fix-only", "--select", "I", "--silent", "-" },
						stdin = true,
					}
				end,
				-- For formatting
				function()
					return {
						exe = "ruff",
						args = { "format", "-" },
						stdin = true,
					}
				end,
			},
		},
	})

	vim.keymap.set("n", "==", ":Format<CR>", { desc = "Format" })
end

return M
