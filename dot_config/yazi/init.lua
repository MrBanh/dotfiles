-- UTILS --

-- https://github.com/boydaihungst/save-clipboard-to-file.yazi
require("save-clipboard-to-file"):setup({
	-- Position of input file name or path dialog
	input_position = { "center", w = 70 },
	-- Position of overwrite confirm dialog
	overwrite_confirm_position = { "center", w = 70, h = 10 },
	-- Hide notify
	hide_notify = false,
})

-- JUMPING --

-- https://github.com/stelcodes/bunny.yazi
require("bunny"):setup({
	hops = {
		-- key and path attributes are required, desc is optional
		{ key = "/", path = "/" },
		{ key = "t", path = "/tmp" },
		{ key = "~", path = "~", desc = "Home" },
		{ key = "d", path = "~/downloads", desc = "downloads" },
		{ key = "D", path = "~/desktop", desc = "desktop" },
		{ key = "c", path = "~/.config", desc = "config files" },
		{ key = "s", path = "~/src" },
		{ key = { "p", "1" }, path = "~/src/pricing-pages-unified-ui/", desc = "pricing-pages-unified-ui" },
		{ key = { "p", "2" }, path = "~/src/self-service-api/", desc = "self-service-api" },
		{
			key = { "p", "3" },
			path = "~/src/growth-monetization-service-types/",
			desc = "growth-monetization-service-types",
		},
		{
			key = { "p", "4" },
			path = "~/src/purchase-staging-ui/",
			desc = "purchase-staging-ui",
		},
		{ key = { "l", "s" }, path = "~/.local/share", desc = "local share" },
		{ key = { "l", "b" }, path = "~/.local/bin", desc = "local bin" },
		{ key = { "l", "t" }, path = "~/.local/state", desc = "local state" },
	},
	desc_strategy = "path", -- if desc isn't present, use "path" or "filename", default is "path"
	ephemeral = true, -- enable ephemeral hops, default is true
	tabs = true, -- enable tab hops, default is true
	notify = false, -- notify after hopping, default is false
	fuzzy_cmd = "fzf", -- fuzzy searching command, default is "fzf"
})

-- https://github.com/dedukun/relative-motions.yazi
require("relative-motions"):setup({ show_numbers = "relative", show_motion = true, enter_mode = "first" })

-- UI --

require("yatline"):setup({
	--theme = my_theme,
	section_separator = { open = "", close = "" },
	part_separator = { open = " ", close = " " },
	inverse_separator = { open = " ", close = " " },

	style_a = {
		fg = "#131A24",
		bg_mode = {
			normal = "#719CD6",
			select = "#9D79D6",
			un_set = "brightred",
		},
	},
	style_b = { bg = "#2F4159", fg = "#CDCECF" },
	style_c = { bg = "reset", fg = "#CDCECF" },

	permissions_t_fg = "green",
	permissions_r_fg = "yellow",
	permissions_w_fg = "red",
	permissions_x_fg = "cyan",
	permissions_s_fg = "white",

	tab_width = 20,
	tab_use_inverse = false,

	selected = { icon = "󰻭", fg = "yellow" },
	copied = { icon = "", fg = "green" },
	cut = { icon = "", fg = "red" },

	total = { icon = "󰮍", fg = "yellow" },
	succ = { icon = "", fg = "green" },
	fail = { icon = "", fg = "red" },
	found = { icon = "󰮕", fg = "blue" },
	processed = { icon = "󰐍", fg = "green" },

	show_background = true,

	display_header_line = true,
	display_status_line = true,

	component_positions = { "header", "tab", "status" },

	header_line = {
		left = {
			section_a = {},
			section_b = {
				{
					type = "string",
					custom = false,
					name = "hovered_name",
					params = { { trimed = false, show_symlink = true, max_length = 24, trim_length = 10 } },
				},
			},
			section_c = {},
		},
		right = {
			section_a = {},
			section_b = {},
			section_c = {},
		},
	},

	status_line = {
		left = {
			section_a = {
				{ type = "string", custom = false, name = "tab_mode" },
			},
			section_b = {},
			section_c = {
				{ type = "string", custom = false, name = "hovered_path" },
				{ type = "string", custom = false, name = "hovered_size" },
				{ type = "coloreds", custom = false, name = "permissions" },
			},
		},
		right = {
			section_a = {},
			section_b = {
				{ type = "string", custom = false, name = "cursor_position" },
				{ type = "string", custom = false, name = "cursor_percentage" },
			},
			section_c = {
				{ type = "coloreds", custom = false, name = "count" },
			},
		},
	},
})

-- https://github.com/yazi-rs/plugins/tree/main/git.yazi
require("git"):setup()

-- https://github.com/sxyazi/yazi/blob/548bb0d063e0d4d00ed299bb519fef64397cc2c3/yazi-plugin/preset/components/linemode.lua
function Linemode:custom()
	local file_size = self._file:size()
	local size = file_size and ya.readable_size(file_size) or "-"

	local time = math.floor(self._file.cha.mtime or 0)
	if time == 0 then
		time = ""
	elseif os.date("%Y", time) == os.date("%Y") then
		time = os.date("%b %d %H:%M", time)
	else
		time = os.date("%b %d  %Y", time)
	end

	return string.format("%s %s", size, time)
end

-- Shows symlink in status bar
Status:children_add(function(self)
	local h = self._current.hovered
	if h and h.link_to then
		return " -> " .. tostring(h.link_to)
	else
		return ""
	end
end, 3300, Status.LEFT)
