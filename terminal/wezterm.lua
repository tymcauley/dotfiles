local wezterm = require("wezterm")

local config = wezterm.config_builder()

-- Appearance

local color_scheme_name = "tokyonight_storm"
local color_scheme = wezterm.color.get_builtin_schemes()[color_scheme_name]

config.color_scheme = color_scheme_name
config.colors = {
    scrollbar_thumb = color_scheme["selection_fg"],
}
config.enable_scroll_bar = true
config.font = wezterm.font("IosevkaTerm Nerd Font") -- TODO use the "Fixed" variant, it disables ligatures

-- System

config.front_end = "WebGpu"
config.term = "wezterm"

return config
