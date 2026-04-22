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
        layout = vim.g.floating_terminal and "float" or "right", ---@type "float"|"left"|"bottom"|"top"|"right"
        float = {
          width = 0.6,
          height = 0.6,
        },
        -- Options used when layout is "left"|"bottom"|"top"|"right"
        ---@type vim.api.keyset.win_config
        split = {
          width = 0, -- set to 0 for default split width
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
  -- Disable cli keybindings, only keeping nes
  keys = function()
    return {
      { "<tab>", LazyVim.cmp.map({ "ai_nes" }, "<tab>"), mode = { "n" }, expr = true },
      {
        "<c-.>",
        false,
      },
    }
  end,
  -- keys = {
  --   {
  --     "<M-/>",
  --     function()
  --       require("sidekick.cli").toggle()
  --     end,
  --     desc = "Sidekick Toggle",
  --     mode = { "n", "t", "i", "x" },
  --   },
  -- },
}
