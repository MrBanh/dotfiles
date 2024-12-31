-- Pull in the wezterm API
local wezterm = require("wezterm")

-- https://github.com/adriankarlen/bar.wezterm
local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

if string.find(wezterm.target_triple, "windows") then
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
	config.default_domain = "SSH:wsl"
	-- config.default_domain = "WSL:Ubuntu"
	config.launch_menu = {
		{
			label = "PowerShell",
			domain = { DomainName = "local" },
			args = { "C:/Program Files/PowerShell/7/pwsh.ex" },
		},
	}
end

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
