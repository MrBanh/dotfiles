local wezterm = require("wezterm")
local ui = require("lua.ui")
local settings = require("lua.settings")
local keymaps = require("lua.keymaps")

-- Plugins
local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")

local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end

settings.apply_to_config(config)
ui.apply_to_config(config)
keymaps.apply_to_config(config)
bar.apply_to_config(config)

return config
