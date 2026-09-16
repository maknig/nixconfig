------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/configuring/core/monitors/

hl.monitor({
    output   = "desc:Dell Inc. DELL U2720Q 8SS2P83",
    mode     = "preferred",
    position = "auto",
    scale    = 1.875,
})

hl.monitor({
    output   = "desc:Dell Inc. DELL U2724DE 6X01M04",
    mode     = "preferred",
    position = "auto",
    scale    = 1.25,
})

hl.monitor({
    output   = "desc:Dell Inc. DELL U2724DE 2Z01M04",
    mode     = "preferred",
    position = "auto",
    scale    = 1.25,
})

hl.monitor({
    output   = "desc:Samsung Electric Company SAMSUNG 0x01000E00",
    mode     = "preferred",
    position = "auto",
    scale    = 1.875,
})

-- Fallback for any other/unlisted monitor
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})
