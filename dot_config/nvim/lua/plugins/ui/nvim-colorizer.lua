return {
  "catgoose/nvim-colorizer.lua",
  event = "BufReadPre",
  opts = {
    filetypes = { "*", "!grug-far", "!snacks_terminal", "!snacks_picker_input", "!sidekick_terminal", "!lazy" },
    buftypes = {},
    user_commands = true,
    lazy_load = false,
    options = {
      parsers = {
        css = true,
        css_fn = true,
        names = {
          enable = true,
          lowercase = true,
          camelcase = true,
          uppercase = false,
          strip_digits = false,
          custom = false,
        },
        hex = {
          default = true,
          rrggbbaa = false,
          aarrggbb = false,
        },
        tailwind = {
          enable = true,
          update_names = true,
        },
        sass = { enable = true, parsers = { css = true } },
      },
      display = {
        mode = "virtualtext",
        virtualtext = {
          char = "󱓻",
          position = "before",
          hl_mode = "foreground",
        },
      },
      always_update = true,
    },
  },
  config = function(_, opts)
    require("colorizer").setup(opts)
  end,
}
