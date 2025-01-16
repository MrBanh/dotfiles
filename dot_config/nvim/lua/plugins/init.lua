return {
  -- neo-tree: file explorer
  -- https://github.com/nvim-neo-tree/neo-tree.nvim
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = function(_, opts)
      opts.window.position = "right"
    end,
  },

  -- https://github.com/anuvyklack/pretty-fold.nvim
  {
    "anuvyklack/pretty-fold.nvim",
    event = "BufReadPost",
    config = function()
      require("pretty-fold").setup({
        keep_indentation = false,
        fill_char = " ",
        sections = {
          left = {
            function()
              -- Calculate the fold level and return the appropriate string
              local level = vim.v.foldlevel
              if level == 0 then
                return "󰁚 "
              else
                return string.rep("  ", level - 1) .. "󰁚 "
              end
            end,
            "content",
          },
          right = {
            "󰁂 ",
            "number_of_folded_lines",
          },
        },
      })
    end,
  },

  {
    "codethread/qmk.nvim",
    lazy = true,
    config = function()
      local conf = {
        name = "LAYOUT_preonic_grid",
        layout = {
          "_ x x x x x x _ x x x x x x",
          "_ x x x x x x _ x x x x x x",
          "_ x x x x x x _ x x x x x x",
          "_ x x x x x x _ x x x x x x",
          "_ x x x x x x _ x x x x x x",
        },
      }
      require("qmk").setup(conf)
    end,
  },

  {
    "snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = [[
                ████                      ████        
              ██░░░░██                  ██░░░░██      
              ██░░░░██                  ██░░░░██      
            ██░░░░░░░░██████████████████░░░░░░░░██    
            ██░░░░░░░░▓▓▓▓░░▓▓▓▓▓▓░░▓▓▓▓░░░░░░░░██    
            ██░░░░░░░░▓▓▓▓░░▓▓▓▓▓▓░░▓▓▓▓░░░░░░░░██    
          ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██  
          ██░░██░░░░████░░░░░░░░░░░░░░████░░░░██░░██  
          ██░░░░██░░████░░░░░░██░░░░░░████░░██░░░░██  
        ██░░░░██░░░░░░░░░░░░██████░░░░░░░░░░░░██░░░░██
        ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██
        ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██
        ██▓▓▓▓░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▓▓▓▓██
        ██▓▓▓▓░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▓▓▓▓██
        ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██
        ]],
        },
      },
    },
  },

  {
    "Wansmer/symbol-usage.nvim",
    event = "LspAttach", -- need run before LspAttach if you use nvim 0.9. On 0.10 use 'LspAttach'
    config = function()
      require("symbol-usage").setup()
    end,
  },

  {
    "axelvc/template-string.nvim",
    config = function()
      require("template-string").setup({
        filetypes = {
          "html",
          "typescript",
          "javascript",
          "typescriptreact",
          "javascriptreact",
          "vue",
          "svelte",
          "python",
        }, -- filetypes where the plugin is active
        jsx_brackets = true, -- must add brackets to JSX attributes
        remove_template_string = false, -- remove backticks when there are no template strings
        restore_quotes = {
          -- quotes used when "remove_template_string" option is enabled
          normal = [[']],
          jsx = [["]],
        },
      })
    end,
  },

  {
    "inkarkat/vim-ReplaceWithRegister",
    keys = {
      { "r", "<Plug>ReplaceWithRegisterOperator", desc = "Replace with register" },
      { "r", "<Plug>ReplaceWithRegisterVisual", desc = "Replace with register visual", mode = "x" },
      { "rr", "<Plug>ReplaceWithRegisterLine", desc = "Riplace with register line" },
    },
  },

  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>yf",
        "<cmd>Yazi<cr>",
        desc = "Open yazi at the current file",
      },
      {
        -- Open in the current working directory
        "<leader>yw",
        "<cmd>Yazi cwd<cr>",
        desc = "Open the file manager in nvim's working directory",
      },
      {
        -- NOTE: this requires a version of yazi that includes
        -- https://github.com/sxyazi/yazi/pull/1305 from 2024-07-18
        "<leader>ys",
        "<cmd>Yazi toggle<cr>",
        desc = "Resume the last yazi session",
      },
    },
    ---@type YaziConfig
    opts = {
      -- if you want to open yazi instead of netrw, see below for more info
      open_for_directories = false,
      keymaps = {
        show_help = "<f1>",
      },
    },
    config = function(_, opts)
      require("yazi").setup(opts)

      local wk = require("which-key")
      wk.add({
        { "<leader>y", group = "󰇥 Yazi" },
      })
    end,
  },
}
