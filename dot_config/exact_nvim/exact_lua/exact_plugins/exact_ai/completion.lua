return {
  {
    "cursortab/cursortab.nvim",
    version = "*", -- Use latest tagged version for more stability
    lazy = false, -- The server is already lazy loaded
    build = "cd server && go build",
    config = function()
      require("cursortab").setup({
        keymaps = {
          trigger = "<M-.>",
        },
        behavior = {
          ignore_filetypes = { "", "markdown", "terminal" }, -- Filetypes to skip completions
          max_visible_lines = 24, -- 0 disables; 12 is default, >0 required to show inline suggestions
        },
        provider = {
          ---@type "copilot" | "fim" | "inline" | "mercuryapi" | "sweep" | "windsurf" | "zeta" | "zeta-2"
          type = "sweep",
          url = "http://localhost:8000",

          -- type = "mercuryapi"
          -- api_key_env = "MERCURY_AI_TOKEN",
        },
      })
    end,
  },
}
