local M = {}

function M.setup()
    M.general()

    M.colemak()
end

function M.general()
    local map = vim.api.nvim_set_keymap

    map('', ';', ':', {}) -- no shift for cmd mode

    -- TODO configure new keybinding
    -- disable some original mappings
    --for _, k in pairs({ 'q', 'a', 'Q' }) do
    --    vim.keymap.set('', k, '<nop>')
    --end

    -- window navigation
    -- ',#' goes to window #
    -- alternatives ',w#', or just '<c-w>', or just 'w' like tabs go with 't'?
    for i = 1, 9 do
        vim.keymap.set('n', ',' .. i, i .. '<c-w>w')
    end

    map("", ";", ":", {}) -- no shift for cmd mode
    map("i", "jj", "<Esc>", {}) -- no shift for cmd mode
    map("", "gp", "`[v`]", { noremap = true }) -- select last pasted lines
    map("", "//", ":nohlsearch<enter>", {}) -- reset search
    
    
    map("", "tt", ":tab split<enter>", {})
    map("", "tT", "<c-w>T", {})
    map("", "tc", ":tabclose<enter>", {})
    map("", "tp", ":tabprevious<enter>", {})
    map("", "tn", ":tabnext<enter>", {})
    map("", "to", ":tabonly<enter>", {})
    -- search for selected text
    -- xnoremap({ "*", '"xy/<c-r><cr>' })

    -- quickfix
    -- map('', 'cj', ':cprev<cr>', {})
    -- map('', 'ck', ':cnext<cr>', {})

    -- Search results centered please
    -- map('', 'n', 'nzz', {})
    -- map('', 'N', 'Nzz', {})
    -- map('', '*', '*zz', {})
    -- map('', '#', '#zz', {})
    -- map('', 'g*', 'g*zz', {})
end

function M.get_maps()
    -- consider https://colemakmods.github.io/mod-dh/model.html

    local maps = {}

    --maps['inverted T arrows'] = {
    --    nv = {
    --        { 'n', 'h' }, -- cursor left
    --        { 'e', 'j' }, -- cursor down
    --        { 'i', 'l' }, -- cursor right
    --        { 'u', 'k' }, -- cursor up
    --    },
    --}

    --maps['browse'] = {
    --    nv = {
    --        { '<c-u>', '1<c-u>' }, -- view and cursor up
    --        { '<c-e>', '1<c-d>' }, -- view and cursor down
    --        -- { '<c-u>', 'kzz' }, -- view and cursor up
    --        -- { '<c-e>', 'jzz' }, -- view and cursor down
    --        { 'zz', 'zz' }, -- center line in view
    --        { 'ze', 'zb' }, -- line at top of view
    --        { 'zu', 'zt' }, -- line at botton of view
    --        { 'k', '<cmd>set scroll=0<enter><c-u><c-u>' }, -- view and cursor one page up
    --        { 'h', '<cmd>set scroll=0<enter><c-d><c-d>' }, -- view and cursor one page down
    --    },
    --}






    maps['undo'] = {
        n = {
            { 'qn', 'u' },
            { 'qi', '<c-r>' },
        },
    }

    maps['copy'] = {
        nv = {
            { 'w', 'y' },
            { 'wa', '"+y' }, -- put into system clipboard
        },
        n = {
            { 'wf', 'p' },
            { 'WF', 'P' },
            { 'ww', 'yy' },
            { 'wp', '`[v`]' }, -- select last pasted lines
            -- { 'wa', '[["+Y]]' }, -- put into system clipboard
        },
    }

    maps['search'] = {
        n = {
            { 'fi', '/' },
            { 'fn', '?' },
            { 'fy', '*' }, -- search word forward
            { 'fl', '#' }, -- search word backward
            { 'E', 'nzz' },
            { 'U', 'Nzz' },
            { 'f,', '<cmd>nohlsearch<enter>' },
        },
    }

    maps['delete'] = {
        nv = {
            { 'd', 'd' },
            -- { 'D', '"_d' },
        },
    }

    maps['tabs'] = {
        n = {
            -- { 'ftu', '<cmd>tab split<enter>' }, -- new tab
            -- { 'ftU', '<c-w>T' }, -- explode into new tab
            { 'ftn', '<cmd>tabprevious<enter>' }, -- previous tab
            { 'fti', '<cmd>tabnext<enter>' }, -- next tab
            { 'ft,', '<cmd>tabclose<enter>' }, -- close tab
            { 'ft.', '<cmd>tabonly<enter>' }, -- only tab
            { 'fth', 'g<tab>' }, -- last tab
            { 'ftl', '<cmd>tabmove -1<enter>' }, -- move tab left
            { 'fty', '<cmd>tabmove +1<enter>' }, -- move tab right
            -- TODO consider ft{digit} for go to
            -- and ft{s-digit} for move tab to
            -- or not needed often enough? keep it in the cmd line?
        },
    }

    maps['splits'] = {
        n = {
            { 'sti', '<cmd>vsplit<enter>' }, -- split right
            { 'stn', '<cmd>set splitright! | vsplit | set splitright!<enter>' }, -- split left
            { 'ste', '<cmd>split<enter>' }, -- split down
            { 'stu', '<cmv>set splitbelow! | split | set splitbelow!<enter>' }, -- split up
            { 'sty', '<cmd>tab split<enter>' }, -- new tab
            { 'stY', '<c-w>T' }, -- explode into new tab
            { 'st,', '<c-w>c' }, -- close split
            -- { "stst,", "<cmd>tabclose<enter>" }, -- close tab
            -- { 'st<', '<cmd>x<enter>' }, -- TODO needed? have a write & close/delete buffer? needed in fugitive commit messages
            { 'st.', '<c-w>o' }, -- only split
            { 'sth', '<c-w>w' }, -- last split
            -- { "ststh", "g<tab>" }, -- last tab
            -- TODO add st{digit}
        },
    }

    -- NOTE lsp is all behind t, is there an easy way to have keys defined centrally?

    -- TODO looking for
    -- q to generally quit? window or tab? qq and qw? move undo then
    -- in an effort to make it similar with fugitive, but could instead make ,x or tsx there too?
    -- how to get those: windows, tabs, and all the go-to stuff (mostly lsp)
    -- especially goto: some leader plus
    --   - right hand for default operation with desired split
    --   - double for either default splitting
    --     - or for pop up preview and then right hand, or leader again for quit/return

    return maps
end

function M.colemak()
    local maps = M.get_maps()
    M.apply_maps(maps)

    -- TODO generally go for alternating and rolling sequences

    -- TODO we could also consider the original stuff behind a leader? in case we need it

    vim.cmd([[
        " visual
        " noremap vv V
        " noremap vs v
        " ideas for text operations
        " noremap p r
        " noremap ss ciw
        " noremap cc cc
    ]])
end

function M.apply_maps(maps, opts)
    for _, sections in pairs(maps) do
        for modes, binds in pairs(sections) do
            modes = vim.iter(string.gmatch(modes, '.')):totable()
            for _, bind in ipairs(binds) do
                vim.keymap.set(modes, bind[1], bind[2], opts)
            end
        end
    end
end

return M
