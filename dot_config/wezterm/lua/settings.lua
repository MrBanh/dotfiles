local wezterm = require("wezterm")
local is_windows = wezterm.target_triple:find("windows") ~= nil

local M = {}

M.apply_to_config = function(config)
	-- Font & Ligatures
	config.font = wezterm.font_with_fallback({
		"JetBrains Mono",
	})
	config.font_size = is_windows and 12 or 15
	config.harfbuzz_features = { "calt=0", "clig=0", "liga=0", "zero" } -- disable ligatures

	-- Windows specific setup to SSH into WSL, for image render to work in terminal
	if is_windows then
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

	-- Set up terminal size
	config.initial_rows = 30
	config.initial_cols = 120

	-- Miscellaneous settings
	config.max_fps = 120
	config.prefer_egl = true
	config.enable_kitty_keyboard = true
end

return M
