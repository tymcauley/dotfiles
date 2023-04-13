local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.color_scheme = "tokyonight_storm"
config.font = wezterm.font("IosevkaTerm Nerd Font") -- TODO use the "Fixed" variant, it disables ligatures
config.front_end = "WebGpu"
config.term = "wezterm"

return config
