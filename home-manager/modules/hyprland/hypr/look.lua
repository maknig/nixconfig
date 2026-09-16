-----------------------
---- LOOK AND FEEL ----
-----------------------

-- See https://wiki.hypr.land/configuring/core/config-options/

hl.config({
    cursor = {
        no_hardware_cursors = true,
    },

    general = {
        gaps_in     = 3,
        gaps_out    = 5,
        border_size = 2,

        col = {
            -- active_border = "rgb(ffc0cb)",
            active_border   = "rgb(80a0c0)",
            inactive_border = "rgba(595959aa)",
        },

        -- layout = "dwindle", -- or master?
        layout = "master",
    },

    decoration = {
        active_opacity     = 1.0,
        inactive_opacity   = 1.0,
        fullscreen_opacity = 1.0,

        rounding = 2,

        -- blur disabled (was commented out in the old config)

        shadow = {
            enabled = false,
            color   = "rgba(1a1a1aee)",
        },

        dim_inactive = false,
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        -- See https://wiki.hypr.land/configuring/layouts/dwindle-layout/ for more
        force_split            = 0,
        special_scale_factor   = 0.8,
        split_width_multiplier = 1.0,
        use_active_for_splits  = true,
        preserve_split         = true,
    },

    master = {
        -- See https://wiki.hypr.land/configuring/layouts/master-layout/ for more
        new_status           = "master",
        special_scale_factor = 0.8,
    },

    misc = {
        disable_autoreload        = false,
        disable_hyprland_logo     = true,
        always_follow_on_dnd      = true,
        layers_hog_keyboard_focus = true,
        animate_manual_resizes    = false,
        enable_swallow            = true,
        swallow_regex             = "",
        focus_on_activate         = true,
    },

    xwayland = {
        force_zero_scaling = true,
    },
})

-- Some default animations, see https://wiki.hypr.land/configuring/core/animations/ for more
hl.curve("overshot", { type = "bezier", points = { { 0.13, 0.99 }, { 0.29, 1.1 } } })

hl.animation({ leaf = "windows",    enabled = true, speed = 4, bezier = "overshot", style = "slide" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 5, bezier = "default",  style = "popin 80%" })
hl.animation({ leaf = "border",     enabled = true, speed = 5, bezier = "default" })
hl.animation({ leaf = "fade",       enabled = true, speed = 8, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "overshot", style = "slidevert" })

-- Gestures (workspace_swipe was left commented out in the old config)
