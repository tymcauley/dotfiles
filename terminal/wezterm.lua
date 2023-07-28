local wezterm = require("wezterm")

local config = wezterm.config_builder()

-- Behavior

config.scrollback_lines = 50000

-- Appearance

local color_scheme_name = "tokyonight_storm"
local color_scheme = wezterm.color.get_builtin_schemes()[color_scheme_name]

config.color_scheme = color_scheme_name
config.colors = {
    scrollbar_thumb = color_scheme["selection_fg"],
}
config.enable_scroll_bar = true
config.font = wezterm.font("IosevkaTerm Nerd Font") -- TODO use the "Fixed" variant, it disables ligatures

-- Key bindings

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
    -- Tabs
    { key = "c", mods = "LEADER", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
    { key = "n", mods = "LEADER", action = wezterm.action.ActivateTabRelative(1) },
    { key = "p", mods = "LEADER", action = wezterm.action.ActivateTabRelative(-1) },
    { key = "a", mods = "LEADER", action = wezterm.action.ActivateLastTab },

    -- Panes
    { key = "h", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Left") },
    { key = "j", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Down") },
    { key = "k", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Up") },
    { key = "l", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Right") },
    { key = "s", mods = "LEADER", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
    { key = "v", mods = "LEADER", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },

    -- Navigation
    { key = "g", mods = "LEADER", action = wezterm.action.ScrollToTop },
    { key = "G", mods = "LEADER|SHIFT", action = wezterm.action.ScrollToBottom },
    { key = "UpArrow", mods = "SHIFT", action = wezterm.action.ScrollToPrompt(-1) },
    { key = "DownArrow", mods = "SHIFT", action = wezterm.action.ScrollToPrompt(1) },

    -- Search
    { key = "/", mods = "LEADER", action = wezterm.action.Search({ CaseSensitiveString = "" }) },

    -- Copy mode
    { key = "[", mods = "LEADER", action = wezterm.action.ActivateCopyMode },
    { key = "x", mods = "LEADER", action = wezterm.action.CopyMode("ClearPattern") },

    -- Domains
    { key = "d", mods = "LEADER", action = wezterm.action.DetachDomain("CurrentPaneDomain") },

    -- Misc
    {
        -- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
        key = "a",
        mods = "LEADER|CTRL",
        action = wezterm.action.SendString("\x01"),
    },
}

-- Navigate through tabs by number
for i = 1, 9 do
    table.insert(config.keys, {
        key = tostring(i),
        mods = "LEADER",
        action = wezterm.action.ActivateTab(i - 1),
    })
end

-- Domains

config.unix_domains = {
    {
        name = "unix",
    },
}
-- Connect to the unix domain on startup.
config.default_gui_startup_args = { "connect", "unix" }

-- System

config.front_end = "WebGpu"
config.term = "wezterm"

return config
