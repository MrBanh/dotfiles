-- Pull in the wezterm API
local wezterm = require("wezterm")

-- https://github.com/adriankarlen/bar.wezterm
local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

config.default_domain = "WSL:Ubuntu"

config.font = wezterm.font_with_fallback({
	"CodeNewRoman Nerd Font",
	"DengXian",
})

-- https://wezfurlong.org/wezterm/colorschemes/index.html
config.color_scheme = "Ayu Mirage"

-- https://wezfurlong.org/wezterm/config/lua/config/window_decorations.html
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true

-- config.window_background_opacity = 0.8
-- config.macos_window_background_blur = 10
config.win32_system_backdrop = "Acrylic"

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- Set up terminal size
config.initial_rows = 30
config.initial_cols = 120

-- Miscellaneous settings
config.max_fps = 120
config.prefer_egl = true

bar.apply_to_config(config)

return config
