-- Do NOT swap back to mini.pairs. It doesn't work well with backticks `
return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },
  {
    "echasnovski/mini.pairs",
    enabled = false,
  },
}
