local mod = {}

function mod.setup()
    ---@diagnostic disable-next-line: redundant-parameter
    require("codecompanion").setup({
		-- CodeCompanion v18+ uses "interactions" instead of "strategies"
		interactions = {
			chat = {
				adapter = "llmhub", -- Point this to your llmhub adapter defined below
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
						},
						headers = {
							["Content-Type"] = "application/json",
						},
						parameters = {
							sync = true,
						},
						schema = {
							model = {
								default = "gemma4:26b",
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
								default = "openai/gpt-oss-20b:free",
							},
						},
					})
				end,
				-- Your Custom LLMHub Adapter
				llmhub = function()
					return require("codecompanion.adapters").extend("openai_compatible", {
						env = {
							url = "https://api.llmhub.infs.ai",
							api_key = "LLMHUB_API_KEY", -- Looks up $LLMHUB_API_KEY from your shell
							chat_url = "/v1/chat/completions",
						},
						schema = {
							model = {
								default = "best-chat", -- Uses the Qwen 3.6 27B model tag we found
							},
						},
					})
				end,
			},
		},
	})
end

return mod
