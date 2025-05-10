return {
  "echasnovski/mini.operators",
  version = "*",
  opts = {
    -- Exchange text regions
    exchange = {
      prefix = "cx",
      -- Whether to reindent new text to match previous indent
      reindent_linewise = true,
    },
    -- multiple (duplicate) text
    multiply = {
      prefix = "gm",
    },
    -- Evaluate text and replace with output
    evaluate = {}, -- evaluate text and replace with output
    replace = {}, -- replace text with register
    sort = {}, -- sort text
  },
  config = function(_, opts)
    require("mini.operators").setup(opts)
  end,
}
