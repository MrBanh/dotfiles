return {
  {
    "3rd/image.nvim",
    build = true, -- do not build with hererocks
    opts = {
      processor = "magick_cli",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = true,
          floating_windows = true, -- if true, images will be rendered in floating markdown windows
          filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
          resolve_image_path = function(document_path, image_path, fallback)
            local obsidian_client = require("obsidian").get_client()
            local new_image_path = obsidian_client:vault_relative_path(image_path).filename
            if vim.fn.filereadable(new_image_path) == 1 then
              return new_image_path
            else
              return fallback(document_path, image_path)
            end
          end,
        },
        html = {
          enabled = true,
        },
        css = {
          enabled = true,
        },
      },
    },
  },

  {
    "abecodes/tabout.nvim",
    lazy = false,
    config = function()
      require("tabout").setup({
        tabkey = "<Tab>", -- key to trigger tabout, set to an empty string to disable
        backwards_tabkey = "<S-Tab>", -- key to trigger backwards tabout, set to an empty string to disable
        act_as_tab = true, -- shift content if tab out is not possible
        act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
        default_tab = "<C-t>", -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
        default_shift_tab = "<C-d>", -- reverse shift default action,
        enable_backwards = true, -- well ...
        completion = false, -- if the tabkey is used in a completion pum
        tabouts = {
          { open = "'", close = "'" },
          { open = '"', close = '"' },
          { open = "`", close = "`" },
          { open = "(", close = ")" },
          { open = "[", close = "]" },
          { open = "{", close = "}" },
        },
        ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
        exclude = {}, -- tabout will ignore these filetypes
      })
    end,
    dependencies = { -- These are optional
      "nvim-treesitter/nvim-treesitter",
    },
    opt = true, -- Set this to true if the plugin is optional
    event = "InsertCharPre", -- Set the event to 'InsertCharPre' for better compatibility
    priority = 1000,
  },

  {
    "akinsho/bufferline.nvim",
    keys = {
      { "<S-tab>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer", mode = "n" },
      { "<tab>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer", mode = "n" },
    },
  },

  -- https://github.com/anuvyklack/pretty-fold.nvim
  {
    "anuvyklack/pretty-fold.nvim",
    event = "BufReadPost",
    opts = {
      sections = {
        left = {
          "content",
        },
        right = {
          "󰁂 ",
          "number_of_folded_lines",
        },
      },
    },
  },

  { "chrisgrieser/nvim-origami", event = "BufReadPost", opts = {} },

  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
      "TmuxNavigatorProcessList",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
    },
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
    "echasnovski/mini.operators",
    version = "*",
    opts = {
      -- Exchange text regions
      exchange = {
        prefix = "cx",
        -- Whether to reindent new text to match previous indent
        reindent_linewise = true,
      },
      -- multiple (duplicate) text
      multiply = {
        prefix = "gm",
      },
      -- Evaluate text and replace with output
      evaluate = {}, -- evaluate text and replace with output
      replace = {}, -- replace text with register
      sort = {}, -- sort text
    },
    config = function(_, opts)
      require("mini.operators").setup(opts)
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

      ---@param img string
      follow_img_func = function(img)
        vim.ui.open(img)
        -- vim.fn.jobstart({ "qlmanage", "-p", img }) -- Mac OS quick look preview
        -- vim.fn.jobstart({"xdg-open", url})  -- linux
        -- vim.cmd(':silent exec "!start ' .. url .. '"') -- Windows
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
        enable = false, -- md ui handled by render-markdown.nvim
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
    "kawre/leetcode.nvim",
    build = ":TSUpdate html", -- if you have `nvim-treesitter` installed
    dependencies = {
      -- "nvim-telescope/telescope.nvim",
      "ibhagwan/fzf-lua",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      lang = "javascript",
      -- image_support = true,
    },
  },

  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    opts = {},
  },

  {
    "lewis6991/hover.nvim",
    config = function()
      require("hover").setup({
        init = function()
          -- Require providers
          require("hover.providers.lsp")
          -- require('hover.providers.gh')
          -- require('hover.providers.gh_user')
          -- require('hover.providers.jira')
          require("hover.providers.dap")
          -- require('hover.providers.fold_preview')
          require("hover.providers.diagnostic")
          require("hover.providers.man")
          require("hover.providers.dictionary")
        end,
        preview_opts = {
          border = "single",
        },
        -- Whether the contents of a currently open hover window should be moved
        -- to a :h preview-window when pressing the hover keymap.
        preview_window = false,
        title = true,
        mouse_providers = {
          "LSP",
        },
        mouse_delay = 1000,
      })

      -- Mouse support
      vim.keymap.set("n", "<MouseMove>", require("hover").hover_mouse, { desc = "hover.nvim (mouse)" })
      vim.o.mousemoveevent = true
    end,
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      html = {
        comment = {
          conceal = false,
        },
      },
    },
  },

  -- https://github.com/folke/snacks.nvim
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

      notifier = {
        top_down = false,
      },

      terminal = {
        win = {
          style = {
            position = "float",
            border = "rounded",
          },
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
    "mbbill/undotree",
    keys = {
      {
        "<leader>su",
        "<cmd>UndotreeToggle<CR>",
        desc = "Find undotree",
        mode = "n",
      },
    },
  },

  {
    "mg979/vim-visual-multi",
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
        { "<leader>y", group = "Yazi", icon = { icon = "󰇥 ", color = "yellow", cat = "extension" } },
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

  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
    opts = {
      provider = "copilot",

      --- @class AvanteFileSelectorConfig
      file_selector = {
        provider = "fzf",
        provider_opts = {},
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make BUILD_FROM_SOURCE=true",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",

      --- The below dependencies are optional

      -- "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "ibhagwan/fzf-lua", -- for file_selector provider fzf
      "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      {
        "saghen/blink.compat",
        lazy = true,
        opts = {},
        config = function()
          -- monkeypatch cmp.ConfirmBehavior for Avante
          require("cmp").ConfirmBehavior = {
            Insert = "insert",
            Replace = "replace",
          }
        end,
      },
      {
        "saghen/blink.cmp",
        lazy = true,
        opts = {
          sources = {
            compat = { "avante_commands", "avante_mentions", "avante_files" },
          },
        },
      },
      "echasnovski/mini.icons",
      -- "nvim-tree/nvim-web-devicons",
      "zbirenbaum/copilot.lua", -- for providers='copilot'
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
}
