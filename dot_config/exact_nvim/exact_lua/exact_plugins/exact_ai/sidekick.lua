local keymap_prefix = "<leader>a"
local toggle = "<M-/>"

-- Neovim's built-in terminal mis-encodes Ctrl+Alt+<letter> under the kitty
-- keyboard protocol: it sends `CSI <ctrl-codepoint>;3u` (e.g. `\27[7;3u` for
-- Ctrl+Alt+g, modifier 3 = Alt only) instead of the canonical
-- `CSI <letter>;7u` (`\27[103;7u`, modifier 7 = Ctrl+Alt). opencode speaks the
-- kitty protocol, so it never recognizes these keybinds. tmux/zellij forward
-- them correctly, which is why they work with mux enabled. With mux disabled,
-- opencode runs directly in nvim's terminal, so we forward the correct bytes.
local function kitty_ctrl_alt(letter)
  return ("\27[%d;7u"):format(letter:byte())
end

local cli_win_keys = {
  prompt = { "<C-a>p", "prompt", mode = "t", desc = "insert prompt or context" },
}

-- ctrl+alt+<letter> keybinds that opencode uses (e.g. messages_last = ctrl+alt+g).
-- Add letters here as needed (b, f, y, e, ... are affected by the same nvim bug).
for _, letter in ipairs({ "g" }) do
  cli_win_keys["ctrl_alt_" .. letter] = {
    "<M-C-" .. letter .. ">",
    function(t)
      if t.job then
        vim.api.nvim_chan_send(t.job, kitty_ctrl_alt(letter))
      end
    end,
    mode = "t",
    desc = "opencode: send ctrl+alt+" .. letter,
  }
end

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
        enabled = false,
      },
      win = {
        keys = cli_win_keys,
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
          require("sidekick.cli").toggle({
            name = "opencode",
          })
        end,
        desc = "Sidekick Toggle",
        mode = { "n", "t", "i", "x" },
      },

      {
        keymap_prefix .. "a",
        function()
          require("snacks.input")({
            prompt = "Ask sidekick: ",
            default = "{this}: ",
            icon = "󰚩 ",
            win = {
              title_pos = "left",
              relative = "cursor",
              row = -3,
              col = 0,
              keys = {
                i_cr = { desc = "submit" },
              },
              b = {
                completion = true,
              },
              bo = {
                filetype = "sidekick_ask",
              },
              on_buf = function(win)
                vim.lsp.start(require("plugins.ai.sidekick.ask_cmp"), { bufnr = win.buf })
              end,
            },
          }, function(input)
            if input and input ~= "" then
              require("sidekick.cli").send({ msg = input, submit = true, focus = true })
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
        mode = { "n", "i", "x" },
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
