local keymap_prefix = "<leader>A"
local toggle = "<M-?>"

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
    }
  end,
}
