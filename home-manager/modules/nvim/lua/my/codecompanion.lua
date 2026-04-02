local mod = {}

function mod.setup()
	---@diagnostic disable-next-line: redundant-parameter
	require("codecompanion").setup({
		interactions = {
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
			},
			inline = {
				adapter = "llmhub",
			},
			cmd = {
				adapter = "llmhub",
			},
		},
		adapters = {
			http = {
				ollama = function()
					return require("codecompanion.adapters").extend("ollama", {
						env = {
							url = "http://nebula:11434",
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
								--default = "qwen3-coder-next:latest",
								default = "qwen3.5:9b",
							},
							num_ctx = {
								default = 20000,
							},
						},
					})
				end,
				openrouter = function()
					return require("codecompanion.adapters").extend("openai_compatible", {
						env = {
							url = "https://openrouter.ai/api",
							api_key = "OPENROUTER_API_KEY",
							chat_url = "/v1/chat/completions",
						},
						schema = {
							model = {
								--default = "qwen/qwen3-4b:free",
								-- default = "openai/gpt-oss-20b:free",
								default = "openai/gpt-oss-20b:free",
							},
						},
					})
				end,
				llmhub = function()
					return require("codecompanion.adapters").extend("openai_compatible", {
						env = {
							url = "https://api.llmhub.infs.ai",
							api_key = "LLMHUB_API_KEY",
							chat_url = "/v1/chat/completions",
						},
						schema = {
							model = {
								--default = "qwen/qwen3-4b:free",
								--default = "openai/gpt-oss-20b:free",
								-- default = "qwen/qwen3-coder-30b",
								default = "best-chat",
							},
						},
					})
				end,
			},
		},
	})
end

return mod
