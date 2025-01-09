-- Astro default plugins: https://docs.astronvim.com/reference/default_plugins/#_top
-- Astro default plugins' configuration files: https://github.com/AstroNvim/AstroNvim/tree/main/lua%2Fastronvim%2Fplugins
-- Docs on customizing plugins: https://docs.astronvim.com/configuration/customizing_plugins/

return {

  -- neo-tree: file explorer
  -- https://github.com/nvim-neo-tree/neo-tree.nvim
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = function(_, opts) opts.window.position = "right" end,
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
    end,
  },

  {
    "akinsho/toggleterm.nvim",
    opts = function(_, opts) opts.direction = "float" end,
  },

  {
    "rcarriga/nvim-notify",
    opts = function(_, opts) opts.top_down = false end,
  },
}
