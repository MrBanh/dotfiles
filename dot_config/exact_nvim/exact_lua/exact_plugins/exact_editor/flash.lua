---@module 'flash'
return {
  "folke/flash.nvim",
  ---@type Flash.Config
  opts = {
    ---@type table<string, Flash.Config>
    modes = {
      -- options used when flash is activated through a regular search with `/` or `?`
      search = {
        enabled = true,
        label = {
          -- otherwise, we might accidentally choose a label that is part of the search pattern and jump to it, causing us to end the search early
          min_pattern_length = 3, -- minimum pattern length to show labels
        },
      },
    },
  },
}
