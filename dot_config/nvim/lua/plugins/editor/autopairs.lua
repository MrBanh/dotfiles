-- Do NOT swap back to mini.pairs. It doesn't work well with backticks `
-- Example:
--- mini: hello |world -> hello `|world -> hello `world| -> hello `world``
--- nvim-autopairs: hello |world -> hello `|world -> hello `world| -> hello `world`
return {
  {
    "saghen/blink.pairs",
    version = "*",
    dependencies = "saghen/blink.download",

    --- @module 'blink.pairs'
    --- @type blink.pairs.Config
    opts = {
      mappings = {
        enabled = true,
        cmdline = true,
        -- or disable with `vim.g.pairs = false` (global) and `vim.b.pairs = false` (per-buffer)
        -- and/or with `vim.g.blink_pairs = false` and `vim.b.blink_pairs = false`
        disabled_filetypes = {
          "TelescopePrompt",
          "codecompanion",
          "grug-far",
          "markdown",
          "opencode",
          "snacks_input",
          "snacks_picker_input",
          "spectre_panel",
        },
        wrap = {
          -- move closing pair via motion
          ["<C-b>"] = "motion",
          -- move opening pair via motion
          ["<C-S-b>"] = "motion_reverse",
          -- set to 'treesitter' or 'treesitter_reverse' to use treesitter instead of motions
          -- set to nil, '' or false to disable the mapping
          -- normal_mode = {} <- for normal mode mappings, only supports 'motion' and 'motion_reverse'
        },
        -- see the defaults:
        -- https://github.com/Saghen/blink.pairs/blob/main/lua/blink/pairs/config/mappings.lua#L52
        pairs = {},
      },
      highlights = {
        enabled = false,
        -- requires require('vim._extui').enable({}), otherwise has no effect
        cmdline = true,
        -- groups = { "BlinkPairsOrange", "BlinkPairsPurple", "BlinkPairsBlue" },
        groups = { "BlinkPairs" }, -- disable rainbow highlighting
        unmatched_group = "BlinkPairsUnmatched",

        -- highlights matching pairs under the cursor
        matchparen = {
          enabled = true,
          -- known issue where typing won't update matchparen highlight, disabled by default
          cmdline = false,
          -- also include pairs not on top of the cursor, but surrounding the cursor
          include_surrounding = false,
          group = "BlinkPairsMatchParen",
          priority = 250,
        },
      },
      debug = false,
    },
  },
  {
    "nvim-mini/mini.pairs",
    enabled = false,
  },
}
