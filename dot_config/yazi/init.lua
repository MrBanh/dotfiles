-- https://github.com/boydaihungst/save-clipboard-to-file.yazi
require("save-clipboard-to-file"):setup({
	-- Position of input file name or path dialog
	input_position = { "center", w = 70 },
	-- Position of overwrite confirm dialog
	overwrite_confirm_position = { "center", w = 70, h = 10 },
	-- Hide notify
	hide_notify = false,
})

-- https://github.com/MasouShizuka/projects.yazi
require("projects"):setup({
	save = {
		method = "yazi", -- yazi | lua
		lua_save_path = "", -- comment out to get the default value
		-- windows: "%APPDATA%/yazi/state/projects.json"
		-- unix: "~/.local/state/yazi/projects.json"
	},
	last = {
		update_after_save = true,
		update_after_load = true,
		load_after_start = false,
	},
	merge = {
		quit_after_merge = false,
	},
	notify = {
		enable = true,
		title = "Projects",
		timeout = 3,
		level = "info",
	},
})

-- https://github.com/dedukun/bookmarks.yazi
require("bookmarks"):setup({
	last_directory = { enable = false, persist = false, mode = "dir" },
	persist = "vim",
	desc_format = "full",
	file_pick_mode = "hover",
	custom_desc_input = false,
	notify = {
		enable = false,
		timeout = 1,
		message = {
			new = "New bookmark '<key>' -> '<folder>'",
			delete = "Deleted bookmark in '<key>'",
			delete_all = "Deleted all bookmarks",
		},
	},
})

-- https://github.com/yazi-rs/plugins/tree/main/git.yazi
require("git"):setup()
