local mod = {}

function mod.setup()
     require("nvim-treesitter").setup {
        highlight = {
            enable = true,
        },
        incremental_selection = {
            enable = false,
            -- TODO try
            -- keymaps = {
            --     init_selection = "gnn",
            --     node_incremental = "grn",
            --     scope_incremental = "grc",
            --     node_decremental = "grm",
            -- },
        },
        indent = { enable = false },
    }
end

return mod
