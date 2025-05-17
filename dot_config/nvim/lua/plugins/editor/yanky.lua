return {
  "gbprod/yanky.nvim",
  config = function(_, opts)
    require("yanky").setup(opts)

    vim.keymap.set("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
    vim.keymap.set("n", "<c-n>", "<Plug>(YankyNextEntry)")
  end,
}
