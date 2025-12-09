-- Do NOT swap back to mini.pairs. It doesn't work well with backticks `
-- Example:
--- mini: hello |world -> hello `|world -> hello `world| -> hello `world``
--- nvim-autopairs: hello |world -> hello `|world -> hello `world| -> hello `world`
return {
  {
    "windwp/nvim-autopairs",
    enabled = false,
    event = "InsertEnter",
    opts = {
      disable_filetype = {
        "TelescopePrompt",
        "codecompanion",
        "grug-far",
        "snacks_input",
        "snacks_picker_input",
        "spectre_panel",
      },
      map_c_w = true, -- map <c-w> to delete a pair if possible
    },
  },
  {
    "nvim-mini/mini.pairs",
    enabled = false,
  },
}
