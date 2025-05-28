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

		-- @alias Provider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
		provider = "openrouter", -- The provider used in Aider mode or in the planning phase of Cursor Planning Mode
		-- WARNING: Since auto-suggestions are a high-frequency operation and therefore expensive,
		-- currently designating it as `copilot` provider is dangerous because: https://github.com/yetone/avante.nvim/issues/1048
		-- Of course, you can reduce the request frequency by increasing `suggestion.debounce`.
		auto_suggestions_provider = "claude",
		cursor_applying_provider = nil, -- The provider used in the applying phase of Cursor Planning Mode, defaults to nil, when nil uses Config.provider as the provider for the applying phase
		openai = {
			endpoint = "",
			model = "qwen2.5-coder:32b",
			temperature = 0,
			max_tokens = 4096,
		},
		vendors = {
			llmhub = {
				__inherited_from = "openai",
				disable_tools = true, -- { "python" },
				endpoint = "https://api.llmhub.infs.ch/v1",
				api_key_name = "LLMHUB_API_KEY",
				model = "llama3.2:3b",
				-- model = "qwq:32b",
			},
			openrouter = {
				__inherited_from = "openai",
				disable_tools = true,
				endpoint = "https://openrouter.ai/api/v1",
				api_key_name = "OPENROUTER_API_KEY",
				model = "google/gemma-3-12b-it:free",
				-- model = "mistralai/mistral-small-3.1-24b-instruct:free",
				-- model = "mistralai/mistral-small-3.1-24b-instruct:free",
				-- model = "meta-llama/llama-4-maverick:free",
			},
		},

		behaviour = {
			auto_suggestions = false, -- Experimental stage
			auto_set_highlight_group = true,
			auto_set_keymaps = true,
			auto_apply_diff_after_generation = false,
			support_paste_from_clipboard = false,
			minimize_diff = true, -- Whether to remove unchanged lines when applying a code block
			enable_token_counting = true, -- Whether to enable token counting. Default to true.
			enable_cursor_planning_mode = true, -- Whether to enable Cursor Planning Mode. Default to false.
		},
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
			sidebar = {
				apply_all = "A",
				apply_cursor = "a",
				switch_windows = "<Tab>",
				reverse_switch_windows = "<S-Tab>",
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
