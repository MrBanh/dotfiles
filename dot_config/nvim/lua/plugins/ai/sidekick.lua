local keymap_prefix = "<leader>A"
local toggle = "<M-?>"

-- Build a location context (used by {this}/{position}/{line}/{file}) without
-- the leading space that sidekick.nvim inserts before `:L<row>`.
-- Upstream renders `@file :L91`; we want `@file:L91` so AI clients can
-- treat the whole token as one reference.
---@param kind "file"|"line"|"position"
local function loc_context(kind)
  return function(ctx)
    local Loc = require("sidekick.cli.context.location")
    if not Loc.is_file(ctx.buf) then
      return false
    end
    local text = Loc.get(ctx, { kind = kind })
    -- text is sidekick.Text[][] — strip a stand-alone " " segment that sits
    -- right before the ":" delimiter.
    for _, line in ipairs(text) do
      for i = #line - 1, 1, -1 do
        if line[i] and line[i][1] == " " and line[i + 1] and line[i + 1][1] == ":" then
          table.remove(line, i)
        end
      end
    end
    return text
  end
end

-- Operator that sends the operated range to sidekick as a {selection}.
-- Mirrors opencode.nvim's `operator()` API but for sidekick.cli.
---@param submit? boolean
local function operator(submit)
  _G.sidekick_send_operator = function(kind)
    local start_pos = vim.api.nvim_buf_get_mark(0, "[")
    local end_pos = vim.api.nvim_buf_get_mark(0, "]")
    if start_pos[1] > end_pos[1] or (start_pos[1] == end_pos[1] and start_pos[2] > end_pos[2]) then
      start_pos, end_pos = end_pos, start_pos
    end

    -- Re-select the operated range so sidekick's {selection} context picks it up.
    local visual = kind == "line" and "V" or kind == "block" and "\22" or "v"
    vim.api.nvim_buf_set_mark(0, "<", start_pos[1], start_pos[2], {})
    vim.api.nvim_buf_set_mark(0, ">", end_pos[1], end_pos[2], {})
    vim.cmd("normal! `<" .. visual .. "`>")

    require("sidekick.cli").send({ msg = "{this}", submit = submit })
  end

  vim.o.operatorfunc = "v:lua.sidekick_send_operator"
  return "g@"
end

return {
  "folke/sidekick.nvim",
  opts = {
    signs = {
      enabled = true, -- enable signs by default
      icon = " ",
    },
    cli = {
      context = {
        position = loc_context("position"),
        line = loc_context("line"),
        file = loc_context("file"),
      },
      mux = {
        backend = "tmux",
        enabled = vim.fn.executable("tmux") == 1,
      },
      win = {
        keys = {
          prompt = { "<C-a>p", "prompt", mode = "t", desc = "insert prompt or context" },
        },
        wo = {
          scrolloff = 0, -- prevent global scrolloff from shifting terminal view on toggle
        },
        -- Force opencode to redraw when sidekick re-opens the terminal window.
        -- Without this, the window-pty association is lost during hide() and the
        -- TUI never receives SIGWINCH, so stale content from the previous render
        -- stays visible until the user manually resizes the split.
        config = function(terminal)
          local orig = terminal.open_win
          terminal.open_win = function(self)
            orig(self)
            vim.defer_fn(function()
              if self:win_valid() and self:is_running() then
                local w = vim.api.nvim_win_get_width(self.win)
                local h = vim.api.nvim_win_get_height(self.win)
                pcall(vim.fn.jobresize, self.job, w - 1, h)
                pcall(vim.fn.jobresize, self.job, w, h)
              end
            end, 30)
          end
        end,
        layout = vim.g.floating_terminal and "float" or "right", ---@type "float"|"left"|"bottom"|"top"|"right"
        float = {
          width = 0.6,
          height = 0.6,
        },
        -- Options used when layout is "left"|"bottom"|"top"|"right"
        ---@type vim.api.keyset.win_config
        split = {
          width = 0.5, -- set to 0 for default split width
          height = 0, -- set to 0 for default split height
        },
      },
    },
    nes = {
      enabled = function(buf)
        local ft = vim.bo[buf].filetype
        if ft == "markdown" then
          return false
        end
        return vim.g.sidekick_nes ~= false and vim.b.sidekick_nes ~= false
      end,
    },
    copilot = {
      status = {
        enabled = false,
      },
    },
  },
  keys = function()
    require("which-key").add({
      {
        keymap_prefix,
        group = "ai/sidekick",
      },
    })

    return {
      -- nes
      { "<tab>", LazyVim.cmp.map({ "ai_nes" }, "<tab>"), mode = { "n" }, expr = true },

      -- cli
      {
        toggle,
        function()
          require("sidekick.cli").toggle()
        end,
        desc = "Sidekick Toggle",
        mode = { "n", "t", "i", "x" },
      },

      {
        keymap_prefix .. "a",
        function()
          vim.ui.input({ prompt = "Ask sidekick: ", default = "{this}: " }, function(input)
            if input and input ~= "" then
              require("sidekick.cli").send({ msg = input, submit = true })
            end
          end)
        end,
        desc = "Ask sidekick",
        mode = { "n", "x" },
      },
      {
        keymap_prefix .. "d",
        function()
          require("sidekick.cli").close()
        end,
        desc = "Detach a CLI Session",
      },
      {
        keymap_prefix .. "f",
        function()
          require("sidekick.cli").focus()
        end,
        desc = "Sidekick Focus",
        mode = { "n", "t", "i", "x" },
      },
      {
        keymap_prefix .. "g",
        function()
          require("sidekick.cli").send({ msg = "{file}" })
        end,
        desc = "Send File",
      },
      {
        keymap_prefix .. "p",
        function()
          require("sidekick.cli").prompt()
        end,
        mode = { "n", "x" },
        desc = "Sidekick Select Prompt",
      },
      {
        keymap_prefix .. "s",
        function()
          require("sidekick.cli").select({ filter = { installed = true } })
        end,
        desc = "Select CLI",
      },
      {
        keymap_prefix .. "t",
        function()
          require("sidekick.cli").send({ msg = "{this}" })
        end,
        mode = { "x", "n" },
        desc = "Send This",
      },
      {
        keymap_prefix .. "v",
        function()
          require("sidekick.cli").send({ msg = "{selection}" })
        end,
        mode = { "x" },
        desc = "Send Visual Selection",
      },
      {
        "go",
        function()
          return operator()
        end,
        mode = { "n", "x" },
        expr = true,
        desc = "Add range to sidekick",
      },
      {
        "goo",
        function()
          return operator() .. "_"
        end,
        expr = true,
        desc = "Add line to sidekick",
      },
    }
  end,
}
