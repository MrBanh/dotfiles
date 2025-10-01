-- Do NOT swap back to mini.pairs. It doesn't work well with backticks `
return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      disable_filetype = { "TelescopePrompt", "spectre_panel", "snacks_picker_input", "codecompanion", "grug-far" },
    },
  },
  {
    "nvim-mini/mini.pairs",
    enabled = false,
  },
}
