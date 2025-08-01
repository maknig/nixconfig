local M = {}

function M.setup()
	require("img-clip").paste_image({
		default = {
			embed_image_as_base64 = false,
			prompt_for_file_name = false,
		},
		use_absolute_path = false,
	})

	require("avante").setup({
		---@alias Provider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
		---@type Provider
		provider = "ollama", -- The provider used in Aider mode or in the planning phase of Cursor Planning Mode
		---@alias Mode "agentic" | "legacy"
		---@type Mode
		mode = "agentic", -- The default mode for interaction. "agentic" uses tools to automatically generate code, "legacy" uses the old planning method to generate code.
		-- WARNING: Since auto-suggestions are a high-frequency operation and therefore expensive,
		-- currently designating it as `copilot` provider is dangerous because: https://github.com/yetone/avante.nvim/issues/1048
		-- Of course, you can reduce the request frequency by increasing `suggestion.debounce`.
		auto_suggestions_provider = "claude",
		cursor_applying_provider = "ollama",
		providers = {
			claude = {
				endpoint = "https://api.anthropic.com",
				model = "claude-3-5-sonnet-20241022",
				extra_request_body = {
					temperature = 0.75,
					max_tokens = 4096,
				},
			},
			ollama = {
				endpoint = "http://152.96.151.56:11434", -- Note that there is no /v1 at the end.
				--model = "qwen2.5-coder:latest",
				model = "gemma3:12b",
				--model = "deepseek-r1:1.5b",
				--model = "qwen2.5-coder:latest",
				--timeout = 30000,
				--extra_request_body = {
				--	options = {
				--		num_ctx = 32768,
				--		temperature = 0,
				--		keep_alive = "5m",
				--	},
				--},
				stream = true,
				-- model = "gemma3:4b",
			},
			openrouter = {
				__inherited_from = "openai",
				disable_tools = false, --{ "python" },
				endpoint = "https://openrouter.ai/api/v1",
				api_key_name = "OPENROUTER_API_KEY",
				--model = "google/gemma-3-12b-it:free",
				model = "qwen/qwen3-8b:free",
				extra_request_body = {
					temperature = 0.75,
					max_tokens = 4096,
				},

				--model = "mistralai/mistral-small-3.1-24b-instruct:free",
				-- model = "mistralai/mistral-small-3.1-24b-instruct:free",
				-- model = "meta-llama/llama-4-maverick:free",
			},
		},
		---Specify the special dual_boost mode
		---1. enabled: Whether to enable dual_boost mode. Default to false.
		---2. first_provider: The first provider to generate response. Default to "openai".
		---3. second_provider: The second provider to generate response. Default to "claude".
		---4. prompt: The prompt to generate response based on the two reference outputs.
		---5. timeout: Timeout in milliseconds. Default to 60000.
		---How it works:
		--- When dual_boost is enabled, avante will generate two responses from the first_provider and second_provider respectively. Then use the response from the first_provider as provider1_output and the response from the second_provider as provider2_output. Finally, avante will generate a response based on the prompt and the two reference outputs, with the default Provider as normal.
		---Note: This is an experimental feature and may not work as expected.
		dual_boost = {
			enabled = false,
			first_provider = "openai",
			second_provider = "claude",
			prompt = "Based on the two reference outputs below, generate a response that incorporates elements from both but reflects your own judgment and unique perspective. Do not provide any explanation, just give the response directly. Reference Output 1: [{{provider1_output}}], Reference Output 2: [{{provider2_output}}]",
			timeout = 60000, -- Timeout in milliseconds
		},
		behaviour = {
			auto_suggestions = false, -- Experimental stage
			auto_set_highlight_group = true,
			auto_set_keymaps = true,
			auto_apply_diff_after_generation = false,
			support_paste_from_clipboard = false,
			minimize_diff = true, -- Whether to remove unchanged lines when applying a code block
			enable_token_counting = true, -- Whether to enable token counting. Default to true.
			auto_approve_tool_permissions = false, -- Default: show permission prompts for all tools
			enable_cursor_planning_mode = true,
			-- Examples:
			-- auto_approve_tool_permissions = true,                -- Auto-approve all tools (no prompts)
            --auto_approve_tool_permissions = { "bash", "replace_in_file" }, -- Auto-approve specific tools only
		},
		--behaviour = {
		--	enable_cursor_planning_mode = false,
		--	auto_focus_sidebar = true,
		--	auto_suggestions = true,
		--	auto_suggestions_respect_ignore = false,
		--	auto_set_highlight_group = true,
		--	auto_set_keymaps = true,
		--	auto_apply_diff_after_generation = true,
		--	jump_result_buffer_on_finish = false,
		--	support_paste_from_clipboard = false,
		--	minimize_diff = true,
		--	enable_token_counting = true,
		--	use_cwd_as_project_root = false,
		--	auto_focus_on_diff_view = false,
		--},
		mappings = {
			--- @class AvanteConflictMappings
			diff = {
				ours = "co",
				theirs = "ct",
				all_theirs = "ca",
				both = "cb",
				cursor = "cc",
				next = "]x",
				prev = "[x",
			},
			suggestion = {
				accept = "<M-l>",
				next = "<M-]>",
				prev = "<M-[>",
				dismiss = "<C-]>",
			},
			jump = {
				next = "]]",
				prev = "[[",
			},
			submit = {
				normal = "<CR>",
				insert = "<C-s>",
			},
			cancel = {
				normal = { "<C-c>", "<Esc>", "q" },
				insert = { "<C-c>" },
			},
			sidebar = {
				apply_all = "A",
				apply_cursor = "a",
				retry_user_request = "r",
				edit_user_request = "e",
				switch_windows = "<Tab>",
				reverse_switch_windows = "<S-Tab>",
				remove_file = "d",
				add_file = "@",
				close = { "<Esc>", "q" },
				close_from_input = nil, -- e.g., { normal = "<Esc>", insert = "<C-d>" }
			},
		},
		hints = { enabled = true },
		windows = {
			---@type "right" | "left" | "top" | "bottom"
			position = "right", -- the position of the sidebar
			wrap = true, -- similar to vim.o.wrap
			width = 40, -- default % based on available width
			sidebar_header = {
				enabled = true, -- true, false to enable/disable the header
				align = "center", -- left, center, right for title
				rounded = true,
			},
			input = {
				prefix = "> ",
				height = 8, -- Height of the input window in vertical layout
			},
			edit = {
				border = "rounded",
				start_insert = true, -- Start insert mode when opening the edit window
			},
			ask = {
				floating = false, -- Open the 'AvanteAsk' prompt in a floating window
				start_insert = true, -- Start insert mode when opening the ask window
				border = "rounded",
				---@type "ours" | "theirs"
				focus_on_apply = "ours", -- which diff to focus after applying
			},
		},
		highlights = {
			---@type AvanteConflictHighlights
			diff = {
				current = "DiffText",
				incoming = "DiffAdd",
			},
		},
		--- @class AvanteConflictUserConfig
		diff = {
			autojump = true,
			---@type string | fun(): any
			list_opener = "copen",
			--- Override the 'timeoutlen' setting while hovering over a diff (see :help timeoutlen).
			--- Helps to avoid entering operator-pending mode with diff mappings starting with `c`.
			--- Disable by setting to -1.
			override_timeoutlen = 500,
		},
		suggestion = {
			debounce = 600,
			throttle = 600,
		},
	})
end

return M
