local keymap_prefix = "<leader>p"

local function chainsaw(name)
  return function()
    require("chainsaw")[name]()
  end
end

return {
  "chrisgrieser/nvim-chainsaw",
  event = "VeryLazy",
  -- required even if left empty
  opts = {
    marker = "[LOG 🪵]",
    visuals = {
      icon = false, ---@type string|false
    },
    -- https://github.com/chrisgrieser/nvim-chainsaw/blob/main/lua/chainsaw/config/log-statements-data.lua
    logStatements = {
      variableLog = {
        javascript = {
          "/* prettier-ignore */ // {{marker}}",
          'console.log("{{marker}} {{filename}}:{{lnum}} - {{var}} → ", {{var}});',
        },
        nvim_lua = "Chainsaw({{var}}) -- {{marker}}",
      },
      objectLog = {
        javascript = {
          "/* prettier-ignore */ // {{marker}}",
          'console.log("{{marker}} {{var}}:", JSON.stringify({{var}}, null, 2))',
        }, -- `2` ensures it's pretty-printed
      },
      emojiLog = {
        javascript = 'console.log("{{marker}} {{emoji}} ------------------");',
      },
    },
  },
  keys = {
    -- variable / value inspection
    { keymap_prefix .. "a", chainsaw("assertLog"), mode = { "n", "x" }, desc = "assert log" },
    { keymap_prefix .. "o", chainsaw("objectLog"), mode = { "n", "x" }, desc = "object log" },
    { keymap_prefix .. "p", chainsaw("variableLog"), mode = { "n", "x" }, desc = "variable log" },
    { keymap_prefix .. "t", chainsaw("typeLog"), mode = { "n", "x" }, desc = "type log" },

    -- control-flow / freeform
    { keymap_prefix .. "e", chainsaw("emojiLog"), desc = "Emoji log" },
    { keymap_prefix .. "m", chainsaw("messageLog"), desc = "Message log" },

    -- diagnostics
    { keymap_prefix .. "b", chainsaw("debugLog"), desc = "debugger / breakpoint" },
    { keymap_prefix .. "s", chainsaw("stacktraceLog"), desc = "stacktrace log" },
    { keymap_prefix .. "S", chainsaw("sound"), desc = "sound log" },
    { keymap_prefix .. "T", chainsaw("timeLog"), desc = "time log" },

    -- Search
    {
      keymap_prefix .. "g",
      function()
        local marker = require("chainsaw.config.config").config.marker
        require("snacks").picker.grep_word({
          title = marker .. " log statements",
          cmd = "rg",
          args = { "--trim" },
          search = "[" .. marker .. "]",
          regex = false,
          live = false,
        })
      end,
      desc = "Find logs",
    },

    -- maintenance
    { keymap_prefix .. "C", chainsaw("clearLog"), desc = "clearing statement, e.g. console.clear()" },
    { keymap_prefix .. "d", chainsaw("removeLogs"), mode = { "n", "x" }, desc = "Remove logs" },
  },
  config = function(_, opts)
    require("chainsaw").setup(opts)
    local ok, wk = pcall(require, "which-key")
    if ok then
      wk.add({
        { keymap_prefix, group = "print log", icon = { icon = "󱞆 " } },
      })
    end
  end,
}
