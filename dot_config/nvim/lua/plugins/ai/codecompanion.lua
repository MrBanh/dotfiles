return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "ravitemer/mcphub.nvim",
  },
  opts = {
    adapters = {
      openrouter_deepseek = function()
        return require("codecompanion.adapters").extend("openai_compatible", {
          name = "openrouter",
          env = {
            url = "https://openrouter.ai/api",
            api_key = "OPENROUTER_API_KEY",
            chat_url = "/v1/chat/completions",
          },
          schema = {
            model = {
              default = "deepseek/deepseek-r1:free",
            },
          },
        })
      end,
      claude = function()
        return require("codecompanion.adapters").extend("copilot", {
          schema = {
            model = {
              default = "claude-3.7-sonnet",
            },
            max_tokens = {
              default = 65536,
            },
          },
        })
      end,
      o3 = function()
        return require("codecompanion.adapters").extend("copilot", {
          schema = {
            model = {
              default = "o3-mini-2025-01-31",
            },
            max_tokens = {
              default = 65536,
            },
          },
        })
      end,
      ["4o"] = function()
        return require("codecompanion.adapters").extend("copilot", {
          schema = {
            model = {
              default = "gpt-4o",
            },
            max_tokens = {
              default = 65536,
            },
          },
        })
      end,
    },
    strategies = {
      chat = {
        tools = {
          ["mcp"] = {
            -- calling it in a function would prevent mcphub from being loaded before it's needed
            callback = function()
              return require("mcphub.extensions.codecompanion")
            end,
            description = "Call tools and resources from the MCP Servers",
            opts = {
              requires_approval = true,
            },
          },
        },
      },
      -- inline = { adapter = "openrouter" },
      -- agent = { adapter = "openrouter" },
    },
    opts = {
      -- Set debug logging
      log_level = "DEBUG",
    },
  },

  keys = {
    {
      mode = "n",
      "<leader>a:",
      function()
        local user_input = vim.fn.input("CodeCompanionCmd: ")
        vim.cmd("CodeCompanionCmd " .. user_input)
      end,
      desc = "CodeCompanionCmd",
    },
    {
      mode = { "n", "v" },
      "<leader>aa",
      "<CMD>CodeCompanionActions<CR>",
      silent = true,
      desc = "CodeCompanion actions",
    },
    {
      mode = { "n" },
      "<leader>ab",
      "<CMD>CodeCompanionChat claude<CR>@editor #buffer<CR>",
      silent = true,
      desc = "CodeCompanion add buffer to chat",
    },
    {
      mode = { "v" },
      "<leader>ab",
      "<CMD>CodeCompanionChat claude<CR><CR>@editor #buffer<CR>",
      silent = true,
      desc = "CodeCompanion add buffer to chat",
    },
    {
      mode = { "n", "v" },
      "<leader>ac",
      "<CMD>CodeCompanionChat Toggle<CR>",
      silent = true,
      desc = "CodeCompanion chat",
    },
    {
      mode = "v",
      "<leader>ay",
      "<CMD>CodeCompanionChat Add<CR>",
      silent = true,
      desc = "CodeCompanion add selection to chat",
    },
    {
      mode = "n",
      "<leader>ag",
      "<CMD>CodeCompanion /commit<CR>",
      silent = true,
      desc = "CodeCompanion generate commit",
    },
  },

  config = function(_, opts)
    require("codecompanion").setup(opts)
    require("which-key").add({
      { "<leader>a", group = "ai", icon = { icon = "󰚩 ", color = "green", cat = "extension" } },
    })
  end,
}
