-- Hyprland Lua config entrypoint.
-- See https://wiki.hypr.land/configuring/ for more.

-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/configuring/core/autostart/

hl.on("hyprland.start", function()
    hl.exec_cmd("waybar & hyprpaper & mako")
    hl.exec_cmd("nm-applet & blueman-applet")
    hl.exec_cmd("hypridle")

    -- Clipboard manager
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/configuring/core/environment-variables/

hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland") -- enables vaapi driver
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

hl.env("GDK_BACKEND", "wayland,x11,*") -- GTK use wayland, fallback to x11
hl.env("QT_QPA_PLATFORM", "wayland;xcb") -- Same for Qt apps

-- Some default env vars.
hl.env("GDK_SCALE", "1")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "48")
hl.env("MOZ_ENABLE_WAYLAND", "1")

---------------------
---- SUBMODULES  ----
---------------------

require("monitors")
require("look")
require("input")
require("binds")
require("windowrules")
