-- Do NOT swap back to mini.pairs. It doesn't work well with backticks `
return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      disable_filetype = { "TelescopePrompt", "spectre_panel", "snacks_picker_input", "codecompanion" },
    },
  },
  {
    "echasnovski/mini.pairs",
    enabled = false,
  },
}
