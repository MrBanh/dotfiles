return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
    opts = {
      debug = true,
      provider = "copilot",

      copilot = {
        endpoint = "https://api.githubcopilot.com",
        model = "o3-mini", -- https://docs.github.com/en/copilot/using-github-copilot/ai-models/changing-the-ai-model-for-copilot-chat
        proxy = nil, -- [protocol://]host[:port] Use this proxy
        allow_insecure = false, -- Allow insecure server connections
        timeout = 30000, -- Timeout in milliseconds
        temperature = 0,
        max_tokens = 4096,
      },

      openai = {
        endpoint = "https://openrouter.ai/api/v1",
        -- model = "google/gemini-2.0-flash-exp:free",
        model = "meta-llama/llama-3.1-70b-instruct:free",
        timeout = 30000, -- Timeout in milliseconds
        temperature = 0,
        max_tokens = 40000,
      },

      file_selector = {
        provider = "snacks", -- native|fzf|mini.pick|snacks|telescope
        provider_opts = {},
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = vim.fn.has("win32") == 1 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
      or "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",

      --- The below dependencies are optional

      -- pickers
      --- "nvim-telescope/telescope.nvim",
      -- "ibhagwan/fzf-lua",

      -- autocompletion
      --- "hrsh7th/nvim-cmp",
      {
        "saghen/blink.cmp",
        lazy = true,
        dependencies = { "saghen/blink.compat" },
        opts = {
          sources = {
            default = { "avante_commands", "avante_mentions", "avante_files" },
            compat = {
              "avante_commands",
              "avante_mentions",
              "avante_files",
            },
            -- LSP score_offset is typically 60
            providers = {
              avante_commands = {
                name = "avante_commands",
                module = "blink.compat.source",
                score_offset = 90,
                opts = {},
              },
              avante_files = {
                name = "avante_files",
                module = "blink.compat.source",
                score_offset = 100,
                opts = {},
              },
              avante_mentions = {
                name = "avante_mentions",
                module = "blink.compat.source",
                score_offset = 1000,
                opts = {},
              },
            },
          },
        },
      },

      -- icons
      "echasnovski/mini.icons",
      -- "nvim-tree/nvim-web-devicons",

      -- providers
      "zbirenbaum/copilot.lua", -- for providers='copilot'

      -- misc
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
    config = function(_, opts)
      require("avante").setup(opts)
      require("which-key").add({
        { "<leader>a", group = "ai", icon = { icon = "󰚩 ", color = "green", cat = "extension" } },
      })
    end,
  },

  -- {
  --   "olimorris/codecompanion.nvim",
  --   enabled = false,
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-treesitter/nvim-treesitter",
  --   },
  --   opts = {
  --     adapters = {
  --       openrouter = function()
  --         return require("codecompanion.adapters").extend("openai_compatible", {
  --           name = "openrouter",
  --           env = {
  --             url = "https://openrouter.ai/api",
  --             api_key = "OPENROUTER_API_KEY",
  --             chat_url = "/v1/chat/completions",
  --           },
  --           schema = {
  --             model = {
  --               default = "meta-llama/llama-3.1-70b-instruct:free",
  --             },
  --           },
  --         })
  --       end,
  --     },
  --     strategies = {
  --       chat = { adapter = "openrouter" },
  --       inline = { adapter = "openrouter" },
  --       agent = { adapter = "openrouter" },
  --     },
  --     opts = {
  --       -- Set debug logging
  --       log_level = "DEBUG",
  --     },
  --   },
  --
  --   keys = {
  --     { mode = "n", "<leader>ac", "<CMD>CodeCompanionChat Toggle<CR>", silent = true, desc = "CodeCompanion chat" },
  --     { mode = "v", "<leader>aa", "<CMD>CodeCompanionActions<CR>", silent = true, desc = "CodeCompanion actions" },
  --     {
  --       mode = "n",
  --       "<leader>a:",
  --       function()
  --         local user_input = vim.fn.input("CodeCompanionCmd: ")
  --         vim.cmd("CodeCompanionCmd " .. user_input)
  --       end,
  --       desc = "CodeCompanionCmd",
  --     },
  --     { mode = "v", "<leader>ay", "<CMD>CodeCompanionChat Add<CR>", silent = true, desc = "CodeCompanion add" },
  --     {
  --       mode = "n",
  --       "<leader>ag",
  --       "<CMD>CodeCompanion /commit<CR>",
  --       silent = true,
  --       desc = "CodeCompanion generate commit",
  --     },
  --   },
  --
  --   config = function(_, opts)
  --     require("codecompanion").setup(opts)
  --     require("which-key").add({
  --       { "<leader>a", group = "ai", icon = { icon = "󰚩 ", color = "green", cat = "extension" } },
  --     })
  --   end,
  -- },

  -- {
  --   "GeorgesAlkhouri/nvim-aider",
  --   enabled = false,
  --   cmd = {
  --     "AiderTerminalToggle",
  --     "AiderHealth",
  --   },
  --   keys = {
  --     { "<leader>a/", "<cmd>AiderTerminalToggle<cr>", desc = "Open Aider" },
  --     { "<leader>as", "<cmd>AiderTerminalSend<cr>", desc = "Send to Aider", mode = { "n", "v" } },
  --     { "<leader>ac", "<cmd>AiderQuickSendCommand<cr>", desc = "Send Command To Aider" },
  --     { "<leader>ab", "<cmd>AiderQuickSendBuffer<cr>", desc = "Send Buffer To Aider" },
  --     { "<leader>a+", "<cmd>AiderQuickAddFile<cr>", desc = "Add File to Aider" },
  --     { "<leader>a-", "<cmd>AiderQuickDropFile<cr>", desc = "Drop File from Aider" },
  --     { "<leader>ar", "<cmd>AiderQuickReadOnlyFile<cr>", desc = "Add File as Read-Only" },
  --     -- Example nvim-tree.lua integration if needed
  --     --- { "<leader>a+", "<cmd>AiderTreeAddFile<cr>", desc = "Add File from Tree to Aider", ft = "NvimTree" },
  --     --- { "<leader>a-", "<cmd>AiderTreeDropFile<cr>", desc = "Drop File from Tree from Aider", ft = "NvimTree" },
  --   },
  --   dependencies = {
  --     "folke/snacks.nvim",
  --     --- The below dependencies are optional
  --     "catppuccin/nvim",
  --     -- "nvim-tree/nvim-tree.lua",
  --   },
  --   config = true,
  -- },
}
