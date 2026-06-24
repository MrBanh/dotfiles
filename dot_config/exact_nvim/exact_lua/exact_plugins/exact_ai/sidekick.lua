local keymap_prefix = "<leader>a"
local toggle = "<M-/>"

return {
  "folke/sidekick.nvim",
  opts = {
    signs = {
      enabled = true, -- enable signs by default
      icon = " ",
    },
    cli = {
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
      tools = {
        opencode = {},
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
  config = function(_, opts)
    -- Prefix the tmux/zellij session name with "sidekick|" and append the cwd
    -- basename (repo/worktree name), e.g. "sidekick|opencode 1a2b3c4d - nvim".
    local Session = require("sidekick.cli.session")
    local original_sid = Session.sid
    ---@diagnostic disable-next-line: duplicate-set-field
    Session.sid = function(o)
      local sid = "sidekick|" .. original_sid(o)
      -- Derive the suffix from the same normalized cwd the plugin uses. It must
      -- stay deterministic from cwd: on rediscovery sidekick recomputes sid from
      -- a running session's cwd and matches it against the live tmux session name
      -- to re-attach (see cli/session/tmux.lua).
      local cwd = Session.cwd(o):gsub("/+$", "")
      -- tmux rewrites "." and ":" in session names to "_"; mirror that so the
      -- recomputed sid still equals the stored tmux session name.
      local name = vim.fn.fnamemodify(cwd, ":t"):gsub("[.:]", "_")
      if name ~= "" then
        sid = sid .. "  " .. name
      end
      return sid
    end
    require("sidekick").setup(opts)
  end,
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
        mode = { "n", "i", "x" },
      },
      {
        keymap_prefix .. "b",
        function()
          require("sidekick.cli").send({ msg = "{file}" })
        end,
        desc = "Send Buffer",
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
    }
  end,
}
