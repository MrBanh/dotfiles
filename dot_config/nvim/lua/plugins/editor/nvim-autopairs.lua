-- Do NOT swap back to mini.pairs. It doesn't work well with backticks `
-- Example:
--- mini: hello |world -> hello `|world -> hello `world| -> hello `world``
--- nvim-autopairs: hello |world -> hello `|world -> hello `world| -> hello `world`
return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      disable_filetype = { "TelescopePrompt", "spectre_panel", "snacks_picker_input", "codecompanion", "grug-far" },
      map_c_w = true, -- map <c-w> to delete a pair if possible
    },
  },
  {
    "nvim-mini/mini.pairs",
    enabled = false,
  },
}
