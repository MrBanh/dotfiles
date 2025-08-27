if true then
  return {}
end

return {
  {
    "zbirenbaum/copilot.lua",
    enabled = false,
  },
  {
    "milanglacier/minuet-ai.nvim",
    event = "BufReadPost",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
    },
    config = function()
      require("minuet").setup({
        provider = "openai",
        virtualtext = {
          auto_trigger_ft = { "*" },
          show_on_completion_menu = false,
          keymap = {
            -- accept whole completion
            accept = "<Tab>", -- handled by blink
            -- accept one line
            accept_line = false,
            -- accept n lines (prompts for number)
            -- e.g. "A-z 2 CR" will accept 2 lines
            accept_n_lines = false,
            -- Cycle to prev completion item, or manually invoke completion
            prev = "<M-[>",
            -- Cycle to next completion item, or manually invoke completion
            next = "<M-]>",
            dismiss = "<C-c>",
          },
        },
        provider_options = {
          openai = {
            -- model = "gpt-5-mini",
            optional = {
              max_completion_tokens = 256,
            },
          },
        },
      })
    end,
  },
  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      keymap = {},
      sources = {
        -- if you want to use auto-complete
        default = { "minuet" },
        providers = {
          minuet = {
            name = "minuet",
            module = "minuet.blink",
            score_offset = 100,
          },
        },
      },
    },
  },
}
