return {
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

  -- https://github.com/epwalsh/obsidian.nvim
  {
    "epwalsh/obsidian.nvim",
    lazy = false,
    -- https://github.com/epwalsh/obsidian.nvim?tab=readme-ov-file#configuration-options
    opts = {
      dir = vim.env.HOME .. "/obsidian-vault", -- specify the vault location. no need to call 'vim.fn.expand' here
      use_advanced_uri = true,
      picker = {
        -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
        name = "fzf-lua",
      },

      templates = {
        folder = "templates",
        date_format = "%Y-%m-%d-%a",
        time_format = "%H:%M",
      },

      daily_notes = {
        -- Optional, if you keep daily notes in a separate directory.
        folder = "Journal",
        date_format = "%Y-%m-%d (%a)",
        -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
        template = "daily-template.md",
      },

      -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
      -- URL it will be ignored but you can customize this behavior here.
      ---@param url string
      follow_url_func = function(url)
        -- Open the URL in the default web browser.
        vim.fn.jobstart({ "open", url }) -- Mac OS
        -- vim.fn.jobstart({"xdg-open", url})  -- linux
        -- vim.cmd(':silent exec "!start ' .. url .. '"') -- Windows
        -- vim.ui.open(url) -- need Neovim 0.10.0+
      end,

      -- Optional, customize frontmatter data
      ---@return table
      note_frontmatter_func = function(note)
        local out = { id = note.id, aliases = note.aliases, tags = note.tags }

        -- `note.metadata` contains any manually added fields in the frontmatter.
        -- So here we just make sure those fields are kept in the frontmatter.
        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end

        return out
      end,

      -- Optional, sort search results by "path", "modified", "accessed", or "created".
      -- The recommend value is "modified" and `true` for `sort_reversed`, which means, for example,
      -- that `:ObsidianQuickSwitch` will show the notes sorted by latest modified time
      sort_by = "modified",
      sort_reversed = true,

      mappings = {
        -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
        ["gf"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },

        -- Smart action depending on context, either follow link or toggle checkbox.
        ["<cr>"] = {
          action = function()
            return require("obsidian").util.smart_action()
          end,
          opts = { buffer = true, expr = true },
        },
      },

      ui = {
        checkboxes = {
          [" "] = { char = "☐", hl_group = "ObsidianTodo" },
          ["x"] = { char = "✔", hl_group = "ObsidianDone" },
        },
      },
    },
    config = function(_, opts)
      require("obsidian").setup(opts)

      require("which-key").add({
        { "<leader>n", group = "Notes/New...", icon = "󰎝 " },
      })

      local del = vim.keymap.del
      del("n", "<Leader>n")

      local set = vim.keymap.set
      set({ "n", "v" }, "<leader>nw", "<Cmd>ObsidianSearch<CR>", { desc = "Obsidian search" })
      set({ "n", "v" }, "<leader>nl", "<Cmd>ObsidianQuickSwitch<CR>", { desc = "Obsidian list" })
      set({ "n", "v" }, "<leader>np", "<Cmd>ObsidianPasteImg<CR>", { desc = "Obsidian paste IMG" })
      set({ "n", "v" }, "<leader>nd", "<Cmd>ObsidianDailies -7 7<CR>", { desc = "Obsidian daily" })
      set({ "n", "v" }, "<leader>nn", function()
        local input = vim.fn.input("File name: ")
        vim.cmd("ObsidianNewFromTemplate " .. input .. ".md")
      end, { desc = "Obsidian template" })
      set({ "n", "v" }, "<leader>nt", "<Cmd>ObsidianToday<CR>", { desc = "Obsidian today" })
      set(
        { "n", "v" },
        "<leader>nr",
        "<Cmd>ObsidianBacklinks<CR>",
        { desc = "Obsidian find references to current buffer" }
      )
      set({ "n", "v" }, "<leader>nR", "<Cmd>ObsidianRename<CR>", { desc = "Obsidian rename file" })
      set({ "n", "v" }, "<leader>no", "<cmd>ObsidianOpen<CR>", { desc = "Open current note in Obsidian app" })
    end,
  },

  -- https://github.com/folke/which-key.nvim?tab=readme-ov-file
  {
    "folke/which-key.nvim",
    opts = {
      preset = "classic",
    },
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

  -- neo-tree: file explorer
  -- https://github.com/nvim-neo-tree/neo-tree.nvim
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = function(_, opts)
      opts.window.position = "right"
    end,
  },
}
