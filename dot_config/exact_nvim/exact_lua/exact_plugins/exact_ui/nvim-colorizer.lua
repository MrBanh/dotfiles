return {
  "catgoose/nvim-colorizer.lua",
  event = "BufReadPre",
  opts = {
    filetypes = {
      "*",
      "!grug-far",
      "!lazy",
      "!sidekick_terminal",
      "!snacks_input",
      "!snacks_picker_input",
      "!snacks_terminal",
    },
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
