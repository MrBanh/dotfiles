return {
  "Davidyz/VectorCode",
  version = "*", -- optional, depending on whether you're on nightly or release
  build = "pipx upgrade vectorcode", -- optional but recommended. This keeps your CLI up-to-date.
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    {
      mode = "n",
      "<leader>avr",
      ":VectorCode register<CR>",
      desc = "VectorCode register",
    },
    {
      mode = "n",
      "<leader>avd",
      ":VectorCode deregister<CR>",
      desc = "VectorCode deregister",
    },
  },
}
