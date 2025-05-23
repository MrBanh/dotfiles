
-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

---@command OpenSourcegraphLink [[
--- Get a sourcegraph link to the current repo + file + line.
--- Automatically opens the link in the default browser.
---@command ]]
vim.api.nvim_create_user_command("OpenSourcegraphLink", function(args)
  print("requesting link...")

  local callback = function(err, link)
    if err or not link then
      print("[sourcegraph] Failed to get link:", link)
      return
    end

    local cmd
    if vim.fn.has("macunix") then
      cmd = "open"
    elseif vim.fn.has("unix") then -- Linux and other Unix-like
      cmd = "xdg-open"
    elseif vim.fn.has("win32") then
      cmd = "start"
    else
      vim.notify("Unsupported OS for opening URL automatically.", vim.log.levels.ERROR)
      return
    end

    local escaped_url = vim.fn.shellescape(link)
    vim.fn.system(cmd .. " " .. escaped_url)
    vim.notify("Opening in browser: " .. link, vim.log.levels.INFO)
  end

  local status, region = pcall(function()
    return vim.region(0, "'<", "'>", "v", true)
  end)

  if not status then
    -- vim.region failed defaulting to cursor position
    local cursor = vim.api.nvim_win_get_cursor(0)
    local row, col = cursor[1], cursor[2]
    local range = { start_line = row, start_col = col, end_line = row, end_col = col }
    require("sg.rpc").get_link(vim.api.nvim_buf_get_name(0), range, callback)
    return
  end

  local keys = vim.tbl_keys(region)
  table.sort(keys)

  local row1 = args.line1 - 1
  local row2 = args.line2 - 1

  local first = keys[1]
  local last = keys[#keys]

  local range
  if first == row1 and last == row2 then
    -- We have a visual selection
    range = {
      start_line = first + 1,
      start_col = region[first][1],
      end_line = last + 1,
      end_col = region[last][2],
    }
  else
    -- Just some range passed, or no range at all
    range = {
      start_line = args.line1,
      start_col = 0,
      end_line = args.line2,
      end_col = 0,
    }
  end

  require("sg.rpc").get_link(vim.api.nvim_buf_get_name(0), range, callback)
end, {
  desc = "Get a sourcegraph link to the current location",
  range = 2,
})

vim.api.nvim_create_user_command("SearchInBrowser", function(args)
  local config = {
    default_engine = "google",
    query_map = {
      google = "https://www.google.com/search?q=%s",
    },
  }

  local function looks_like_url(input)
    local pat = "[%w%.%-_]+%.[%w%.%-_/]+"
    return input:match(pat) ~= nil
  end

  local function extract_prefix(input)
    local pat = "@(%w+)"
    local prefix = input:match(pat)
    if not prefix or not config.query_map[prefix] then
      return vim.trim(input), config.default_engine
    end
    local query = input:gsub("@" .. prefix, "")
    return vim.trim(query), prefix
  end

  local function query_browser(input)
    local q, prefix = extract_prefix(input)
    if not looks_like_url(input) then
      local format = config.query_map[prefix]
      q = format:format(vim.uri_encode(q))
    end
    vim.ui.open(q)
  end

  vim.ui.input({ prompt = "Search: " }, function(input)
    if input then
      query_browser(input)
    end
  end)
end, {
  desc = "Search in browser",
})
