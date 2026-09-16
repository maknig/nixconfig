---------------
---- INPUT ----
---------------

-- For all categories, see https://wiki.hypr.land/configuring/core/config-options/

hl.config({
    input = {
        kb_layout  = "us,ch",
        kb_variant = "",
        kb_model   = "",
        kb_options = "grp:alt_space_toggle",
        kb_rules   = "",

        follow_mouse = 1,

        float_switch_override_focus = 2,

        natural_scroll = true,

        touchpad = {
            natural_scroll = true,
        },

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.
    },
})
