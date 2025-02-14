local mod = {}

function mod.setup()
	local map = vim.keymap.set
	local telescope = require("telescope")
	local actions = require("telescope.actions")
	local bi = require("telescope.builtin")

	local defaults = require("telescope.themes").get_ivy({ layout_config = { height = 0.4 } })
	--local defaults = require('telescope.themes').get_dropdown({ layout_config = {  max_columns=120 } })
	defaults.scroll_strategy = "limit"
	defaults.mappings = {
		i = {
			["<c-j>"] = actions.move_selection_next,
			["<c-k>"] = actions.move_selection_previous,
			["<enter>"] = actions.select_default,
			["<c-v>"] = actions.select_vertical,
			["<c-s>"] = actions.select_horizontal,
			["<c-t>"] = actions.select_tab,
			["<tab>"] = actions.toggle_selection + actions.move_selection_next,
			["<s-tab>"] = actions.toggle_all,
		},
		n = {
			["q"] = actions.close,
			["j"] = "move_selection_next",
			["k"] = "move_selection_previous",
			["<enter>"] = actions.select_default,
			["<c-v>"] = actions.select_vertical,
			["<c-s>"] = actions.select_horizontal,
			["<c-t>"] = actions.select_tab,
			["<tab>"] = actions.toggle_selection + actions.move_selection_next,
			["<s-tab>"] = actions.toggle_all,
		},
	}
	defaults.path_display = { "truncate" }

	telescope.setup({
		defaults = defaults,
		extensions = {
			-- https://github.com/nvim-telescope/telescope-fzf-native.nvim#telescope-setup-and-configuration
			fzf = {},
		},
	})
	telescope.load_extension("fzf")

	-- Function to show spell suggestions
	function SpellSuggestions()
		local current_word = vim.fn.expand("<cword>")
		bi.spell_suggest({
			initial_mode = "insert",
			prompt_title = "Spell Suggestions for: " .. current_word,
			search = current_word,
		})
	end

	map("n", ",ss", ":lua SpellSuggestions()<CR>", { desc = "Spell suggestions" })

	map("", ",,", ":Telescope git_files<cr>", { desc = "find git files" })
	map("n", "gds", bi.lsp_document_symbols, { desc = "document symbols" })
	map("n", "gws", bi.lsp_dynamic_workspace_symbols, { desc = "workspace symbols" })
	map("n", "gf", bi.find_files, { desc = "find files" })

	-- map('n', 'gr', bi.live_grep, { desc = 'live grep' })
	map("n", "gn", bi.buffers, { desc = "buffers" })
	map("n", "go", bi.help_tags, { desc = "help tags" })
	map("n", "gm", function()
		bi.man_pages({ sections = { "ALL" } })
	end, { desc = "man pages" })
	map("n", "gt", bi.commands, { desc = "vim commands" })
	map("n", "gc", mod.git_diff_files, {})

	map("n", "gu", function()
		bi.diagnostics({ bufnr = 0 })
	end, { desc = "lsp diagnostic buffer messages" })
	map("n", "g,", function()
		bi.diagnostics({ bufnr = nil })
	end, { desc = "lsp diagnostic all messages" })
end

function mod.git_diff_files(opts)
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local list = vim.fn.systemlist("git diff --name-only master 2>/dev/null | git diff --name-only main")

	pickers
		.new(opts, {
			prompt_title = "git diff to main/master",
			finder = finders.new_table({ results = list }),
			sorter = conf.generic_sorter(opts),
		})
		:find()
end

return mod
