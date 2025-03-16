return {
  -- {
  --   "yetone/avante.nvim",
  --   event = "VeryLazy",
  --   lazy = false,
  --   version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
  --   opts = {
  --     debug = true,
  --     provider = "copilot",
  --
  --     copilot = {
  --       endpoint = "https://api.githubcopilot.com",
  --       model = "o3-mini", -- https://docs.github.com/en/copilot/using-github-copilot/ai-models/changing-the-ai-model-for-copilot-chat
  --       proxy = nil, -- [protocol://]host[:port] Use this proxy
  --       allow_insecure = false, -- Allow insecure server connections
  --       timeout = 30000, -- Timeout in milliseconds
  --       temperature = 0,
  --       max_tokens = 4096,
  --       disable_tools = true,
  --     },
  --
  --     openai = {
  --       endpoint = "https://openrouter.ai/api/v1",
  --       -- model = "google/gemini-2.0-flash-exp:free",
  --       model = "meta-llama/llama-3.1-70b-instruct:free",
  --       timeout = 30000, -- Timeout in milliseconds
  --       temperature = 0,
  --       max_tokens = 40000,
  --     },
  --
  --     file_selector = {
  --       provider = "snacks", -- native|fzf|mini.pick|snacks|telescope
  --       provider_opts = {},
  --     },
  --
  --     -- The system_prompt type supports both a string and a function that returns a string. Using a function here allows dynamically updating the prompt with mcphub
  --     system_prompt = function()
  --       local hub = require("mcphub").get_hub_instance()
  --       return hub:get_active_servers_prompt()
  --     end,
  --     -- The custom_tools type supports both a list and a function that returns a list. Using a function here prevents requiring mcphub before it's loaded
  --     custom_tools = function()
  --       return {
  --         require("mcphub.extensions.avante").mcp_tool(),
  --       }
  --     end,
  --   },
  --   -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  --   build = vim.fn.has("win32") == 1 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
  --     or "make",
  --   -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  --   dependencies = {
  --     "stevearc/dressing.nvim",
  --     "nvim-lua/plenary.nvim",
  --     "MunifTanjim/nui.nvim",
  --     "ravitemer/mcphub.nvim",
  --
  --     --- The below dependencies are optional
  --
  --     -- pickers
  --     --- "nvim-telescope/telescope.nvim",
  --     -- "ibhagwan/fzf-lua",
  --
  --     -- autocompletion
  --     --- "hrsh7th/nvim-cmp",
  --     "saghen/blink.cmp",
  --
  --     -- icons
  --     "echasnovski/mini.icons",
  --     -- "nvim-tree/nvim-web-devicons",
  --
  --     -- providers
  --     "zbirenbaum/copilot.lua", -- for providers='copilot'
  --
  --     -- misc
  --     {
  --       -- support for image pasting
  --       "HakonHarnes/img-clip.nvim",
  --       event = "VeryLazy",
  --       opts = {
  --         -- recommended settings
  --         default = {
  --           embed_image_as_base64 = false,
  --           prompt_for_file_name = false,
  --           drag_and_drop = {
  --             insert_mode = true,
  --           },
  --           -- required for Windows users
  --           use_absolute_path = true,
  --         },
  --       },
  --     },
  --     {
  --       -- Make sure to set this up properly if you have lazy=true
  --       "MeanderingProgrammer/render-markdown.nvim",
  --       opts = {
  --         file_types = { "markdown", "Avante" },
  --       },
  --       ft = { "markdown", "Avante" },
  --     },
  --   },
  --   config = function(_, opts)
  --     require("avante").setup(opts)
  --     require("which-key").add({
  --       { "<leader>a", group = "ai", icon = { icon = "󰚩 ", color = "green", cat = "extension" } },
  --     })
  --   end,
  -- },
  --
  -- {
  --   "saghen/blink.cmp",
  --   dependencies = {
  --     "Kaiser-Yang/blink-cmp-avante",
  --     "rafamadriz/friendly-snippets",
  --     {
  --       "saghen/blink.compat",
  --       optional = true, -- make optional so it's only enabled if any extras need it
  --       opts = {},
  --       version = not vim.g.lazyvim_blink_main and "*",
  --     },
  --   },
  --   opts = {
  --     sources = {
  --       -- Add 'avante' to the list
  --       default = { "avante", "lsp", "path", "snippets", "buffer" },
  --       providers = {
  --         avante = {
  --           module = "blink-cmp-avante",
  --           name = "Avante",
  --           opts = {
  --             -- options for blink-cmp-avante
  --           },
  --         },
  --       },
  --     },
  --   },
  -- },
  --

  {
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
      { mode = "n", "<leader>ac", "<CMD>CodeCompanionChat Toggle<CR>", silent = true, desc = "CodeCompanion chat" },
      { mode = "v", "<leader>aa", "<CMD>CodeCompanionActions<CR>", silent = true, desc = "CodeCompanion actions" },
      {
        mode = "n",
        "<leader>a:",
        function()
          local user_input = vim.fn.input("CodeCompanionCmd: ")
          vim.cmd("CodeCompanionCmd " .. user_input)
        end,
        desc = "CodeCompanionCmd",
      },
      { mode = "v", "<leader>ay", "<CMD>CodeCompanionChat Add<CR>", silent = true, desc = "CodeCompanion add" },
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
  },

  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim", -- Required for Job and HTTP requests
    },
    -- cmd = "MCPHub", -- lazily start the hub when `MCPHub` is called
    build = "npm install -g mcp-hub@latest", -- Installs required mcp-hub npm module
    config = function()
      require("mcphub").setup({
        -- Required options
        port = 3000, -- Port for MCP Hub server
        config = vim.fn.expand("~/.config/mcpservers.json"), -- Absolute path to config file

        -- Optional options
        on_ready = function(hub)
          -- Called when hub is ready
        end,
        on_error = function(err)
          -- Called on errors
        end,
        shutdown_delay = 0, -- Wait 0ms before shutting down server after last client exits
        log = {
          level = vim.log.levels.WARN,
          to_file = false,
          file_path = nil,
          prefix = "MCPHub",
        },
      })
    end,
  },

  -- {
  --   "GeorgesAlkhouri/nvim-aider",
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
