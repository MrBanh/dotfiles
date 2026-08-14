local usercmd = vim.api.nvim_create_user_command

usercmd("SearchInBrowser", function(args)
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
    else
      -- Ensure URL has a protocol
      if not q:match("^https?://") then
        q = "https://" .. q
      end
    end
    vim.ui.open(q)
  end

  if args.args and #args.args > 0 then
    query_browser(args.args)
    return
  end

  vim.ui.input({ prompt = "Search: " }, function(input)
    if input then
      query_browser(input)
    end
  end)
end, {
  desc = "Search in browser",
  nargs = "?",
})

usercmd("Btop", function()
  if vim.fn.executable("btop") == 1 then
    Snacks.terminal.toggle("btop", {
      win = {
        style = "terminal",
        width = 0,
        height = 0,
      },
    })
  else
    Snacks.notify.error("btop is not installed. Please install it to use this command.", {
      title = "Btop",
    })
  end
end, {
  desc = "Toggle btop in terminal",
})

usercmd("Gh", function()
  if vim.fn.executable("gh") == 1 then
    Snacks.terminal.toggle({ "gh", "dash" }, {
      win = {
        style = "terminal",
        width = 0,
        height = 0,
      },
    })
  else
    Snacks.notify.error("gh-dash is not installed. Please install it with: `gh extension install dlvhdr/gh-dash`", {
      title = "gh-dash",
    })
  end
end, {
  desc = "Toggle gh-dash in terminal",
})
