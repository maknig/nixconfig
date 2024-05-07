local map = vim.api.nvim_set_keymap

map("", ";", ":", {}) -- no shift for cmd mode
map("i", "jj", "<Esc>", {}) -- no shift for cmd mode
map("", "gp", "`[v`]", { noremap = true }) -- select last pasted lines
map("", "//", ":nohlsearch<enter>", {}) -- reset search

-- keep selection when indent/outdent
-- xnoremap({ ">", ">gv" })
-- xnoremap({ "<", "<gv" })

-- search for selected text
-- xnoremap({ "*", '"xy/<c-r><cr>' })

-- tab navigation
-- caveat: t is a default mapping for 'until'
map("", "tt", ":tab split<enter>", {})
map("", "tT", "<c-w>T", {})
map("", "tc", ":tabclose<enter>", {})
map("", "tp", ":tabprevious<enter>", {})
map("", "tn", ":tabnext<enter>", {})
map("", "to", ":tabonly<enter>", {})

map("", "∆", ":m+<CR>", {})
map("", "˚", ":m-2<CR>", {})

--nnormap('<tab>', pumvisible() ? "\<C-n>" : "\<Tab>", "expr")
--nnormap('<S-Tab>', pumvisible() ? "\<C-p>" : "\<S-Tab>", "expr")

--local function t(str)
--    return vim.api.nvim_replace_termcodes(str, true, true, true)
--end
--
--function _G.smart_tab()
--    return vim.fn.pumvisible() == 1 and t'<C-n>' or t'<Tab>'
--end
--
--vim.api.nvim_set_keymap('i', '<Tab>', 'v:lua.smart_tab()', {expr = true, noremap = true})
-- function tab_completion()
--     if vim.fn['vsnip#jumpable'](1) > 0 then
--       return utils.esc('<Plug>(vsnip-jump-next)')
--     end

--     if vim.fn.pumvisible() > 0 then
--       return utils.esc('<C-n>')
--     end

--     if check_back_space() then
--       return utils.esc('<TAB>')
--     end

--     if vim.fn['vsnip#expandable']() > 0 then
--       return utils.esc('<Plug>(vsnip-expand)')
--     end

--     return vim.fn['compe#complete']()
--   end

-- vim.api.nvim_set_keymap('i', '<Tab>', 'v:lua.tab_completion()', {expr = true, noremap = true})
-- utils.keymap('i', '<TAB>', 'v:lua.tab_completion()', { expr = true, noremap = false })

-- utils.keymap('i', '<S-TAB>', 'pumvisible() ? "<C-p>" : vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : "<S-TAB>"', {
--   expr = true,
--   noremap = false
-- })

-- utils.keymap('s', '<TAB>', 'vsnip#available(1)  ? "<Plug>(vsnip-expand-or-jump)" : "<TAB>"', {
--   expr = true,
--   noremap = false
-- })

-- utils.keymap('s', '<S-TAB>', 'vsnip#available(-1)  ? "<Plug>(vsnip-jump-prev)" : "<S-TAB>"', {
--   expr = true,
--   noremap = false
-- })
