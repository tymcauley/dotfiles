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
config.font = wezterm.font("IosevkaTerm NF") -- TODO use the "Fixed" variant, it disables ligatures

-- Key bindings

local act = wezterm.action

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
    -- Tabs
    { key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
    { key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
    { key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
    { key = "a", mods = "LEADER", action = act.ActivateLastTab },
    { key = "n", mods = "LEADER|SHIFT", action = act.MoveTabRelative(1) },
    { key = "p", mods = "LEADER|SHIFT", action = act.MoveTabRelative(-1) },

    -- Panes
    { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
    { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
    { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
    { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
    { key = "s", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
    { key = "v", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },

    -- Navigation
    { key = "g", mods = "LEADER", action = act.ScrollToTop },
    { key = "G", mods = "LEADER|SHIFT", action = act.ScrollToBottom },
    { key = "UpArrow", mods = "SHIFT", action = act.ScrollToPrompt(-1) },
    { key = "DownArrow", mods = "SHIFT", action = act.ScrollToPrompt(1) },

    -- Search
    { key = "/", mods = "LEADER", action = act.Search({ CaseSensitiveString = "" }) },

    -- Copy mode
    { key = "[", mods = "LEADER", action = act.ActivateCopyMode },
    { key = "x", mods = "LEADER", action = act.CopyMode("ClearPattern") },

    -- Domains
    { key = "d", mods = "LEADER", action = act.DetachDomain("CurrentPaneDomain") },

    -- Misc

    -- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
    { key = "a", mods = "LEADER|CTRL", action = act.SendString("\x01") },
}

-- Navigate through tabs by number
for i = 1, 9 do
    table.insert(config.keys, { key = tostring(i), mods = "LEADER", action = act.ActivateTab(i - 1) })
end

-- Domains

-- Disable while this causes screen-refresh issues with vim
-- config.unix_domains = {
--     {
--         name = "unix",
--     },
-- }
-- -- Connect to the unix domain on startup.
-- config.default_gui_startup_args = { "connect", "unix" }

-- Don't remove the "SSH_CLIENT" variable from the multiplexer server environment when connecting over SSH, it's useful
-- for prompts to detect if the shell is running over ssh.
config.mux_env_remove = {
    "SSH_AUTH_SOCK",
    "SSH_CONNECTION",
}

-- System

config.front_end = "WebGpu"
config.term = "wezterm"

return config
