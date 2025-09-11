local wezterm = require("wezterm")

local M = {}

M.apply_to_config = function(config)
	config.keys = {
		{
			key = "w",
			mods = "SHIFT|CTRL",
			action = wezterm.action.CloseCurrentPane({ confirm = true }),
		},
		{
			key = "w",
			mods = "CMD",
			action = wezterm.action.DisableDefaultAssignment,
		},
		{
			key = "Enter",
			mods = "ALT",
			action = wezterm.action.DisableDefaultAssignment,
		},
		{
			key = "m",
			mods = "SHIFT|CTRL",
			action = wezterm.action.DisableDefaultAssignment,
		},
	}
end

return M
