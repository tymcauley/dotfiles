local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.color_scheme = "tokyonight_storm"
config.font = wezterm.font("Iosevka Nerd Font")
config.front_end = "WebGpu"
config.term = "wezterm"

return config
