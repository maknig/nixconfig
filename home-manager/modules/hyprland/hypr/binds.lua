---------------------
---- KEYBINDINGS ----
---------------------

-- See https://wiki.hypr.land/configuring/core/binds/ for more

local mainMod = "SUPER"

hl.bind(mainMod .. " + SHIFT + Return", hl.dsp.exec_cmd("alacritty"))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exit())
hl.bind(mainMod .. " + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd('rofi -show combi -modes combi -combi-modes "window,drun,run" -matching fuzzy'))
hl.bind(mainMod .. " + O", hl.dsp.exec_cmd("google-chrome-stable"))

-- Locking and session management
hl.bind(mainMod .. " + escape", hl.dsp.exec_cmd("powermenu"))
hl.bind(mainMod .. " + SHIFT + escape", hl.dsp.exec_cmd("hyprlock"))

-- Move focus with mainMod + arrow keys (vim-style)
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))

-- Resize active window (relative resize, was `resizeactive`)
hl.bind(mainMod .. " + SHIFT + h", hl.dsp.window.resize({ x = -40, y = 0, relative = true }))
hl.bind(mainMod .. " + SHIFT + l", hl.dsp.window.resize({ x = 40, y = 0, relative = true }))
hl.bind(mainMod .. " + SHIFT + k", hl.dsp.window.resize({ x = 0, y = -40, relative = true }))
hl.bind(mainMod .. " + SHIFT + j", hl.dsp.window.resize({ x = 0, y = 40, relative = true }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Move current workspace to screen
-- NOTE: verify "l"/"r" are accepted as relative monitor selectors for
-- hl.dsp.workspace.move's `monitor` field; that mirrors the old
-- `movecurrentworkspacetomonitor l/r` behavior.
hl.bind(mainMod .. " + CTRL + left", hl.dsp.workspace.move({ monitor = "l" }))
hl.bind(mainMod .. " + CTRL + right", hl.dsp.workspace.move({ monitor = "r" }))

-- Media / multimedia keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"))
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 5%+"), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { repeating = true })

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- NOTE: the old `binds { workspace_back_and_forth = 1; allow_workspace_cycles = 1 }`
-- block has no direct Lua equivalent config option found. The explicit
-- "previous" workspace selector below (mainMod+TAB) already provides the
-- back-and-forth toggle behavior for the common use case.

-- Copy paste manager
hl.bind("SUPER + V", hl.dsp.exec_cmd("cliphist list | rofi -dmenu | cliphist decode | wl-copy"))

-- Screenshot
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd("hyprshot -m window")) -- a window
hl.bind("Print", hl.dsp.exec_cmd("hyprshot -m output")) -- a monitor
hl.bind(mainMod .. " + SHIFT + Print", hl.dsp.exec_cmd("hyprshot -m region")) -- a region
hl.bind(mainMod .. " + CTRL + P", hl.dsp.exec_cmd("hyprshot -m region")) -- a region

hl.bind(mainMod .. " + TAB", hl.dsp.focus({ workspace = "previous" }))

hl.bind(mainMod .. " + Return", hl.dsp.layout("swapwithmaster master"))

hl.bind("ALT + TAB", hl.dsp.window.cycle_next({ next = true }), { repeating = true })
hl.bind("ALT + SHIFT + TAB", hl.dsp.window.cycle_next({ next = false }), { repeating = true })
