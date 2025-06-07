return {
  "gbprod/substitute.nvim",
  event = "VeryLazy",
  config = function()
    require("substitute").setup {
      on_substitute = require("yanky.integration").substitute(),
    }

    vim.keymap.set("n", "r", require("substitute").operator, { noremap = true, desc = "Substitute" })
    vim.keymap.set("x", "r", require("substitute").visual, { noremap = true, desc = "Substitute" })
    vim.keymap.set("n", "rr", require("substitute").line, { noremap = true, desc = "Substitute line" })
    vim.keymap.set("n", "R", require("substitute").eol, { noremap = true, desc = "Substitute eol" })
    vim.keymap.set("n", "rx", require("substitute.exchange").operator, { noremap = true, desc = "Exchange" })
    vim.keymap.set("x", "rx", require("substitute.exchange").visual, { noremap = true, desc = "Exchange" })
    vim.keymap.set("n", "rxx", require("substitute.exchange").line, { noremap = true, desc = "Exchange line" })
  end,
}
