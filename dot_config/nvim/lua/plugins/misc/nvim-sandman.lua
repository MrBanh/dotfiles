return {
  "stasfilin/nvim-sandman",
  config = function()
    require("nvim_sandman").setup({
      enabled = false,
      mode = "allowlist", -- block_all | blocklist | allowlist
      allow = {
        "bend.nvim",
        "copilot.lua",
        "lazy.nvim",
        "plenary.nvim",
        "sg.nvim",
        "snacks.nvim",
      },
      on_block = function(info) end,
    })
  end,
}
