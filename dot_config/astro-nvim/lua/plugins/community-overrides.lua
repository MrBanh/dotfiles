return {
  {
    "nvimdev/lspsaga.nvim",
    opts = {
      ui = {
        code_action = " 󱐌 ",
      },
      lightbulb = {
        enable = false,
        sign = false,
        virtual_text = false,
      },
    },
  },
  {
    "yetone/avante.nvim",
    opts = {
      debug = true,
      provider = "openai",
      openai = {
        endpoint = "https://openrouter.ai/api/v1",
        -- model = "anthropic/claude-3.5-sonnet",
        model = "meta-llama/llama-3.1-70b-instruct:free",
        timeout = 30000, -- Timeout in milliseconds
        temperature = 0,
        max_tokens = 40000,
      },
    },
  },
}
