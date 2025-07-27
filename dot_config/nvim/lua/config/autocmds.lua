-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- USER COMMANDS

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

-- -- Organize imports on save for JS/TS
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   callback = function()
--     local fts = {
--       "javascript",
--       "javascriptreact",
--       "typescript",
--       "typescriptreact",
--     }
--     local ft = vim.bo.filetype
--     for _, v in ipairs(fts) do
--       if ft == v then
--         vim.lsp.buf.code_action({
--           context = { only = { "source.organizeImports" }, diagnostics = {} },
--           apply = true,
--         })
--         return
--       end
--     end
--   end,
-- })
