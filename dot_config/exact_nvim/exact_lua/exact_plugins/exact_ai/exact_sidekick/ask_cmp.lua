-- ---------------------------------------------------------------------------
-- LSP-backed completion for the "Ask sidekick" prompt.
--
-- Mirrors how opencode.nvim provides completion in its `ask()` UI: an
-- in-process LSP server is started on the snacks.input buffer. blink.cmp's
-- default `lsp` source then surfaces the items, and `completionItem/resolve`
-- returns a rendered preview of the token (e.g. {diagnostics} expands to the
-- actual diagnostics text) as markdown documentation.
--
-- Usage from a snacks.input call:
--
--   require("snacks.input")({
--     prompt = "Ask sidekick: ",
--     win = {
--       bo = { filetype = "sidekick_ask" },
--       on_buf = function(win)
--         vim.lsp.start(require("plugins.ai.sidekick.ask_cmp"), { bufnr = win.buf })
--       end,
--     },
--   }, ...)
-- ---------------------------------------------------------------------------

---Build the list of available context tokens.
---Pulls from sidekick's built-in registry AND any user-defined `cli.context`
---entries so custom contexts also get completion.
---@return string[]
local function context_names()
  local Context = require("sidekick.cli.context")
  local Config = require("sidekick.config")

  local names = {}
  local seen = {}

  -- Built-in contexts (Context.context: position, file, line, buffers,
  -- diagnostics, diagnostics_all, quickfix, selection, function, class, this).
  for name in pairs(Context.context or {}) do
    if not seen[name] then
      seen[name] = true
      table.insert(names, name)
    end
  end

  -- User-defined contexts (from `cli.context` in setup opts).
  for name in pairs((Config.cli or {}).context or {}) do
    if not seen[name] then
      seen[name] = true
      table.insert(names, name)
    end
  end

  table.sort(names)
  return names
end

---LSP request handlers. Same shape as opencode.nvim's in-process LSP.
local handlers = {}
local lsp_methods = vim.lsp.protocol.Methods

handlers[lsp_methods.initialize] = function(_, callback)
  callback(nil, {
    capabilities = {
      completionProvider = {
        resolveProvider = true,
        triggerCharacters = { "{" },
      },
    },
    serverInfo = { name = "sidekick_ask_cmp" },
  })
end

handlers[lsp_methods.textDocument_completion] = function(_, callback)
  local items = {}
  for _, name in ipairs(context_names()) do
    local label = "{" .. name .. "}"
    table.insert(items, {
      label = label,
      filterText = label,
      insertText = label,
      insertTextFormat = vim.lsp.protocol.InsertTextFormat.PlainText,
      kind = vim.lsp.protocol.CompletionItemKind.Variable,
    })
  end
  callback(nil, items)
end

handlers[lsp_methods.completionItem_resolve] = function(params, callback)
  local item = vim.deepcopy(params)

  -- Render the token to preview what will actually be sent to the CLI.
  local ok, rendered = pcall(function()
    local Context = require("sidekick.cli.context")
    local ctx = Context.get()
    local text = ctx:render({ msg = item.label, this = false })
    return text
  end)

  if ok and type(rendered) == "string" and rendered ~= "" then
    item.documentation = {
      kind = "markdown",
      value = "```\n" .. rendered .. "\n```",
    }
  end

  callback(nil, item)
end

---@type vim.lsp.Config
return {
  name = "sidekick_ask_cmp",
  filetypes = { "sidekick_ask" },
  cmd = function()
    return {
      request = function(method, params, callback)
        if handlers[method] then
          handlers[method](params, callback)
        end
      end,
      notify = function() end,
      is_closing = function()
        return false
      end,
      terminate = function() end,
    }
  end,
}
