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

-- BOOKMARKS / JUMPING --

-- https://github.com/dedukun/bookmarks.yazi
require("bookmarks"):setup({
	last_directory = { enable = true, persist = true, mode = "dir" },
	persist = "all",
	desc_format = "full",
	file_pick_mode = "parent",
	custom_desc_input = false,
	show_keys = true,
	notify = {
		enable = true,
		timeout = 1,
		message = {
			new = "New bookmark '<key>' -> '<folder>'",
			delete = "Deleted bookmark in '<key>'",
			delete_all = "Deleted all bookmarks",
		},
	},
})

-- https://github.com/stelcodes/bunny.yazi
require("bunny"):setup({
	hops = {
		-- key and path attributes are required, desc is optional
		{ key = "/", path = "/" },
		{ key = "c", path = "~/.config" },
		{ key = "d", path = "~/downloads" },
		{ key = "D", path = "~/desktop" },
		{ key = "h", path = "~" },
		{ key = { "l", "s" }, path = "~/.local/share" },
		{ key = { "l", "b" }, path = "~/.local/bin" },
		{ key = { "l", "t" }, path = "~/.local/state" },
		{ key = "s", path = "~/src" },
		{ key = "t", path = "/tmp" },
	},
	desc_strategy = "path", -- if desc isn't present, use "path" or "filename", default is "path"
	ephemeral = true, -- enable ephemeral hops, default is true
	tabs = true, -- enable tab hops, default is true
	notify = true, -- notify after hopping, default is false
	fuzzy_cmd = "fzf", -- fuzzy searching command, default is "fzf"
})

-- https://github.com/dedukun/relative-motions.yazi
require("relative-motions"):setup({ show_numbers = "relative", show_motion = true, enter_mode = "first" })

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

	return string.format("%s | %s", size, time)
end

-- Show symlink target in status bar
Status:children_add(function(self)
	local h = self._current.hovered
	if h and h.link_to then
		return " -> " .. tostring(h.link_to)
	else
		return ""
	end
end, 3300, Status.LEFT)

-- Show selected / yanked files in status bar
Status:children_add(function(self)
	local files_yanked = #cx.yanked
	local files_selected = #cx.active.selected
	local files_cut = cx.yanked.is_cut

	local selected_fg = files_selected > 0 and "yellow" or "grey"
	local yanked_fg = files_yanked > 0 and (files_cut and "magenta" or "green") or "grey"

	local selected_text = files_selected > 0 and "󰼢 " .. files_selected or "󰼢 " .. "0"
	local yanked_text = files_yanked > 0 and "󱉨 " .. files_yanked or "󱉨 " .. "0"

	return ui.Line({
		ui.Span(" "),
		ui.Span(selected_text):fg(selected_fg),
		ui.Span(" "),
		ui.Span(yanked_text):fg(yanked_fg),
	})
end, 4000, Status.LEFT)
