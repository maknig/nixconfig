local mod = {}

function mod.setup()
	---@diagnostic disable-next-line: redundant-parameter
	require("codecompanion").setup({
		strategies = {
			chat = {
				adapter = "ollama",
				keymaps = {
					send = {
						modes = { n = "<C-s>", i = "<C-s>" },
						opts = {},
					},
					close = {
						modes = { n = "<C-c>", i = "<C-c>" },
						opts = {},
					},
				},
				variables = {
					["buffer"] = {
						callback = "strategies.chat.variables.buffer",
						description = "Share the current buffer with the LLM",
						opts = {
							contains_code = true,
							default_params = "watch",
							has_params = true,
						},
					},
				},
				slash_commands = {
					["file"] = {
						callback = "strategies.chat.slash_commands.file",
						description = "Select a file using Telescope",
						opts = {
							provider = "telescope",
							contains_code = true,
						},
					},
				},
			},
			inline = {
				adapter = "ollama",
			},
			cmd = {
				adapter = "ollama",
			},
		},
		adapters = {
			anthropic = function()
				return require("codecompanion.adapters").extend("anthropic", {
					env = {
						api_key = "cmd:op read op://personal/anthropic/credential --no-newline",
					},
				})
			end,
			ollama = function()
				return require("codecompanion.adapters").extend("ollama", {
					env = {
						url = "http://152.96.151.56:11434",
						api_key = "OLLAMA_API_KEY",
					},
					headers = {
						["Content-Type"] = "application/json",
						["Authorization"] = "Bearer ${api_key}",
					},
					parameters = {
						sync = true,
					},
					schema = {
						model = {
							default = "qwen3:latest",
						},
						num_ctx = {
							default = 20000,
						},
					},
				})
			end,
		},
	})
end

return mod
