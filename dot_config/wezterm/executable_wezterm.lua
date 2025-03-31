-- Pull in the wezterm API
local wezterm = require("wezterm")

-- https://github.com/adriankarlen/bar.wezterm
local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

config.font = wezterm.font_with_fallback({
	"CodeNewRoman Nerd Font",
	"JetBrains Mono",
	"DengXian",
})
config.font_size = 14

local is_windows = wezterm.target_triple:find("windows") ~= nil

if is_windows then
	config.font_size = 12

	-- To get this to work:
	-- 1. Configure on wsl:
	--    * `/etc/ssh/sshd_config` to accept PORT 22, ListenAddress 127.0.0.1
	--    * Generate host keys: `sudo ssh-keygen -A`
	-- 2. On host machine:
	--		* Generate SSH key pair in powershell: `ssh-keygen -t rsa -b 4096`
	-- 		* Copy the public key to WSL: `type $env:USERPROFILE\.ssh\id_rsa.pub | ssh tony@localhost "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"`
	-- If you get "REMOTE HOST IDENTIFICATION CHANGED", follow these steps:
	--    1. In powershell: `cd ~/.ssh` and check `known_hosts`
	-- 		2. Delete lines that correspond to 127.0.0.1 or localhost
	config.ssh_backend = "Ssh2"

	-- https://yazi-rs.github.io/docs/image-preview/#wsl
	-- Starts the wsl SSH from pwsh -> connect to it with wezterm ssh client
	config.default_prog =
		{ "pwsh", "-command", "wsl -- sudo service ssh start && wezterm cli spawn --domain-name SSH:wsl" }

	-- config.default_domain = "WSL:Ubuntu"

	config.launch_menu = {
		{
			label = "PowerShell",
			domain = { DomainName = "local" },
			args = { "C:/Program Files/PowerShell/7/pwsh.ex" },
		},
	}
end

-- https://wezfurlong.org/wezterm/colorschemes/index.html
config.color_scheme = "Ayu Mirage"

-- https://wezfurlong.org/wezterm/config/lua/config/window_decorations.html
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true

-- Transparency
local opacity = 0.8
wezterm.on("window-focus-changed", function(window, pane)
	local overrides = window:get_config_overrides() or {}
	if window:is_focused() then
		overrides.window_background_opacity = 1
	else
		overrides.window_background_opacity = opacity
	end
	window:set_config_overrides(overrides)
end)
config.window_background_opacity = opacity
config.macos_window_background_blur = 20
config.win32_system_backdrop = "Acrylic"

config.window_padding = {
	left = 8,
	right = 8,
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
