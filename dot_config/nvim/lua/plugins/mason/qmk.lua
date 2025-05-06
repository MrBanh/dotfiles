return {
  "codethread/qmk.nvim",
  lazy = true,
  config = function()
    local conf = {
      name = "LAYOUT_preonic_grid",
      layout = {
        "_ x x x x x x _ x x x x x x",
        "_ x x x x x x _ x x x x x x",
        "_ x x x x x x _ x x x x x x",
        "_ x x x x x x _ x x x x x x",
        "_ x x x x x x _ x x x x x x",
      },
    }
    require("qmk").setup(conf)
  end,
}
