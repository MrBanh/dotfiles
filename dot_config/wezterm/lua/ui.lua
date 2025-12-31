local wezterm = require("wezterm")

local M = {}

M.apply_to_config = function(config)
	-- https://wezfurlong.org/wezterm/config/lua/config/window_decorations.html
	config.window_decorations = "RESIZE"
	config.hide_tab_bar_if_only_one_tab = true

	-- https://wezfurlong.org/wezterm/colorschemes/index.html
	config.color_scheme = "Rapture"
	-- config.color_scheme = "nightfox"

	-- Transparency
	local opacity = 0.8
	wezterm.on("window-focus-changed", function(window, pane)
		local overrides = window:get_config_overrides() or {}
		if window:is_focused() then
			overrides.window_background_opacity = 0.9
		else
			overrides.window_background_opacity = opacity
		end
		window:set_config_overrides(overrides)
	end)
	config.window_background_opacity = opacity
	config.macos_window_background_blur = 50
	config.win32_system_backdrop = "Acrylic"

	config.window_padding = {
		left = 8,
		right = 8,
		top = 0,
		bottom = 0,
	}
end

return M
