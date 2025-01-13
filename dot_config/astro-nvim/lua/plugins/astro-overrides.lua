-- Astro default plugins: https://docs.astronvim.com/reference/default_plugins/#_top
-- Astro default plugins' configuration files: https://github.com/AstroNvim/AstroNvim/tree/main/lua%2Fastronvim%2Fplugins
-- Docs on customizing plugins: https://docs.astronvim.com/configuration/customizing_plugins/

return {

  -- neo-tree: file explorer
  -- https://github.com/nvim-neo-tree/neo-tree.nvim
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = function(_, opts)
      opts.window.position = "right"

      local function on_move(data) Snacks.rename.on_rename_file(data.source, data.destination) end
      local events = require "neo-tree.events"
      opts.event_handlers = opts.event_handlers or {}
      vim.list_extend(opts.event_handlers, {
        { event = events.FILE_MOVED, handler = on_move },
        { event = events.FILE_RENAMED, handler = on_move },
      })
    end,
  },

  -- nvim-treesitter: Syntax highlighting
  -- https://github.com/nvim-treesitter/nvim-treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- list like portions of a table cannot be merged naturally and require the user to merge it manually
      -- check to make sure the key exists
      if not opts.ensure_installed then opts.ensure_installed = {} end
      vim.list_extend(opts.ensure_installed, {
        "lua",
        "vim",
        "astro",
        "css",
        "devicetree",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "tsx",
        "typescript",
        "vim",
        "yaml",
      })
    end,
  },

  -- Fuzzy Finder (files, lsp, etc)
  -- https://github.com/nvim-telescope/telescope.nvim
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "mollerhoj/telescope-recent-files.nvim",
      "xvzc/chezmoi.nvim",
    },
    keys = {
      {
        "<leader>ff",
        function()
          require("telescope").extensions["recent-files"].recent_files {
            follow = true,
          }
        end,
        desc = "Find files",
      },
      {
        "<leader>fp",
        function() require("telescope").extensions.projects.projects {} end,
        desc = "Find projects",
      },
      {
        "<leader>f.",
        function() require("telescope").extensions.chezmoi.find_files() end,
        desc = "Find chezmoi config",
      },
    },
    opts = {
      pickers = {
        find_files = {
          follow = true,
        },
        live_grep = {
          additional_args = { "--follow" },
        },
        grep_string = {
          additional_args = { "--follow" },
        },
      },
    },
    config = function(plugin, opts)
      -- run the core AstroNvim configuration function with the options table
      require "astronvim.plugins.configs.telescope"(plugin, opts)

      -- require telescope and load extensions as necessary
      require("telescope").load_extension "recent-files"
      require("telescope").load_extension "chezmoi"
    end,
  },

  {
    "akinsho/toggleterm.nvim",
    opts = function(_, opts) opts.direction = "float" end,
  },

  {
    "rcarriga/nvim-notify",
    opts = function(_, opts)
      opts.top_down = false
      opts.background_colour = "#000000"
    end,
  },

  {
    "nvim-web-devicons",
    opts = {
      override_by_filename = {
        [".chezmoiignore"] = {
          icon = "",
        },
        [".chezmoiremove"] = {
          icon = "",
        },
        [".chezmoiroot"] = {
          icon = "",
        },
        [".chezmoiversion"] = {
          icon = "",
        },
        ["bash.tmpl"] = { icon = "" },
        ["json.tmpl"] = { icon = "" },
        ["ps1.tmpl"] = { icon = "󰨊" },
        ["sh.tmpl"] = { icon = "" },
        ["toml.tmpl"] = { icon = "" },
        ["yaml.tmpl"] = { icon = "" },
        ["zsh.tmpl"] = { icon = "" },
      },
    },
  },
}
