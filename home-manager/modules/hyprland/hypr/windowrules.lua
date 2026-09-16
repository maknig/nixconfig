--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/configuring/core/rules/ for more

-- Sushi preview
hl.window_rule({ name = "sushi-float", match = { class = "sushi" }, float = true })

-- Common modal dialogs
hl.window_rule({ name = "open-dialog-float",           match = { title = "Open" },                             float = true })
hl.window_rule({ name = "choose-files-dialog-float",   match = { title = "Choose Files" },                     float = true })
hl.window_rule({ name = "save-as-dialog-float",        match = { title = "Save As" },                          float = true })
hl.window_rule({ name = "confirm-replace-dialog-float",match = { title = "Confirm to replace files" },         float = true })
hl.window_rule({ name = "file-op-progress-float",      match = { title = "File Operation Progress" },          float = true })

-- Chrome file dialogs
hl.window_rule({ name = "chrome-open-files-float", match = { class = "google-chrome", title = "Open Files" }, float = true })
hl.window_rule({ name = "chrome-open-file-float",  match = { class = "google-chrome", title = "Open File" },  float = true })

-- NetworkManager dialogs
hl.window_rule({ name = "nm-openconnect-auth-float", match = { class = "nm-openconnect-auth-dialog" }, float = true, center = true })
hl.window_rule({ name = "nm-connection-editor-float", match = { class = "nm-connection-editor" }, float = true, center = true })

-- PulseAudio volume control
hl.window_rule({
    name  = "pavucontrol-float",
    match = { class = "org.pulseaudio.pavucontrol" },
    float = true,
    center = true,
    size = { 800, 600 },
})

-- Calculator
hl.window_rule({ name = "gnome-calculator-float", match = { class = "org.gnome.Calculator" }, float = true, center = true })

-- Nautilus Previewer
hl.window_rule({
    name  = "nautilus-previewer-float",
    match = { class = "org.gnome.NautilusPreviewer" },
    float = true,
    center = true,
    size = { 800, 600 },
})

-- Evolution alarm notifications
hl.window_rule({ name = "evolution-alarm-float", match = { class = "evolution-alarm-notify" }, float = true, center = true })

-- Blueman Manager
hl.window_rule({
    name  = "blueman-manager-float",
    match = { class = ".blueman-manager-wrapped" },
    float = true,
    center = true,
    size = { 800, 600 },
})
