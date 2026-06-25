-- ---------------------------------------------------------------------------
-- snacks.nvim picker/explorer integration for sidekick.nvim.
--
-- sidekick.nvim ships no built-in picker action, but exposes the primitives:
--   * require("sidekick.cli").send({ msg, submit, focus })
--   * require("sidekick.cli.context.location").get(...) -> `@relpath :L:C` mention
--
-- This adds a `sidekick_send` picker action that formats the selected item(s)
-- as sidekick `@file` mentions and inserts them into the CLI prompt (focused,
-- not auto-submitted) -- mirroring opencode.nvim's picker `prompt()` flow.
--
-- Bound to <A-a> in every picker (input + list) and explicitly on the explorer.
-- This is a separate snacks.nvim spec; LazyVim merges it with the other
-- snacks specs (e.g. lua/plugins/editor/explorer.lua).
-- ---------------------------------------------------------------------------

---@param picker snacks.Picker
local function sidekick_send(picker)
  local Loc = require("sidekick.cli.context.location")
  local Text = require("sidekick.text")
  local cwd = picker:cwd()

  local parts = {} ---@type string[]
  for _, item in ipairs(picker:selected({ fallback = true })) do
    if item.file then
      local loc = Loc.get({
        name = vim.fs.normalize(vim.fn.fnamemodify(item.file, ":p")),
        cwd = cwd,
        row = item.pos and item.pos[1] or nil,
        col = item.pos and item.pos[2] or nil,
        range = item.end_pos and { from = item.pos, to = item.end_pos, kind = "char" } or nil,
      }, { kind = item.pos and "position" or "file" })
      parts[#parts + 1] = Text.to_string(loc)
    elseif item.text then
      parts[#parts + 1] = item.text
    end
  end

  if #parts == 0 then
    return
  end

  require("sidekick.cli").send({
    msg = table.concat(parts, " ") .. " ",
    submit = false, -- let the user add a question and submit themselves
    focus = true,
  })
end

local send_keys = {
  input = {
    keys = {
      ["<M-CR>"] = { "sidekick_send", mode = { "n", "i" } },
    },
  },
  list = {
    keys = {
      ["<M-CR>"] = "sidekick_send",
    },
  },
}

---@type LazySpec
return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      actions = {
        sidekick_send = sidekick_send,
      },
      -- Applies to every picker (input box + results list).
      win = send_keys,
      sources = {
        -- Explicit binding on the explorer so it's guaranteed there too.
        explorer = {
          win = send_keys,
        },
      },
    },
  },
}
