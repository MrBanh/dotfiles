return {
  {
    "akinsho/bufferline.nvim",
    enabled = false,
    keys = {
      { "<S-tab>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer", mode = "n" },
      { "<tab>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer", mode = "n" },
    },
  },

  {
    "bullets-vim/bullets.vim",
    ft = { "markdown", "text", "gitcommit", "scratch" },
    config = function()
      -- Disable deleting the last empty bullet when pressing <cr> or 'o'
      -- default = 1
      vim.g.bullets_delete_last_bullet_if_empty = 1
    end,
  },

  {
    "chrishrb/gx.nvim",
    keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } } },
    cmd = { "Browse" },
    init = function()
      vim.g.netrw_nogx = 1 -- disable netrw gx
    end,
    config = true, -- default settings
    submodules = false, -- not needed, submodules are required only for tests
  },

  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    keys = function()
      local keys = {
        {
          "<leader>M",
          function()
            require("harpoon"):list():add()
          end,
          desc = "Harpoon File",
        },
        {
          "<leader>m",
          function()
            local harpoon = require("harpoon")
            harpoon.ui:toggle_quick_menu(harpoon:list())
          end,
          desc = "Harpoon Quick Menu",
        },
      }
      return keys
    end,
  },

  {
    "lewis6991/hover.nvim",
    config = function()
      require("hover").setup({
        init = function()
          -- Require providers
          require("hover.providers.lsp")
          require("hover.providers.gh")
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

  {
    "skardyy/neo-img",
    build = function()
      require("neo-img").install()
    end,
    config = function()
      require("neo-img").setup({
        auto_open = false, -- Automatically open images when buffer is loaded
        oil_preview = false, -- changes oil preview of images too
      })
    end,
  },

  {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {
      filetypes = { "*" }, -- Filetype options.  Accepts table like `user_default_options`
      buftypes = {}, -- Buftype options.  Accepts table like `user_default_options`
      -- Boolean | List of usercommands to enable.  See User commands section.
      user_commands = true, -- Enable all or some usercommands
      lazy_load = false, -- Lazily schedule buffer highlighting setup function
      user_default_options = {
        names = true, -- "Name" codes like Blue or red.  Added from `vim.api.nvim_get_color_map()`
        names_opts = { -- options for mutating/filtering names.
          lowercase = true, -- name:lower(), highlight `blue` and `red`
          camelcase = true, -- name, highlight `Blue` and `Red`
          uppercase = false, -- name:upper(), highlight `BLUE` and `RED`
          strip_digits = false, -- ignore names with digits,
          -- highlight `blue` and `red`, but not `blue3` and `red4`
        },
        -- Expects a table of color name to #RRGGBB value pairs.  # is optional
        -- Example: { cool = "#107dac", ["notcool"] = "ee9240" }
        -- Set to false to disable, for example when setting filetype options
        names_custom = false, -- Custom names to be highlighted: table|function|false
        RGB = true, -- #RGB hex codes
        RGBA = true, -- #RGBA hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        RRGGBBAA = false, -- #RRGGBBAA hex codes
        AARRGGBB = false, -- 0xAARRGGBB hex codes
        rgb_fn = false, -- CSS rgb() and rgba() functions
        hsl_fn = false, -- CSS hsl() and hsla() functions
        css = true, -- Enable all CSS *features*:
        -- names, RGB, RGBA, RRGGBB, RRGGBBAA, AARRGGBB, rgb_fn, hsl_fn
        css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
        -- Tailwind colors.  boolean|'normal'|'lsp'|'both'.  True sets to 'normal'
        tailwind = true, -- Enable tailwind colors
        tailwind_opts = { -- Options for highlighting tailwind names
          update_names = true, -- When using tailwind = 'both', update tailwind names from LSP results.  See tailwind section
        },
        -- parsers can contain values used in `user_default_options`
        sass = { enable = true, parsers = { "css" } }, -- Enable sass colors
        -- Highlighting mode.  'background'|'foreground'|'virtualtext'
        mode = "virtualtext", -- Set the display mode
        -- Virtualtext character to use
        virtualtext = "■",
        -- Display virtualtext inline with color.  boolean|'before'|'after'.  True sets to 'after'
        virtualtext_inline = "before",
        -- Virtualtext highlight mode: 'background'|'foreground'
        virtualtext_mode = "foreground",
        -- update color values even if buffer is not focused
        -- example use: cmp_menu, cmp_docs
        always_update = true,
        -- hooks to invert control of colorizer
        hooks = {
          -- called before line parsing.  Set to function that returns a boolean and accepts the following parameters.  See hooks section.
          do_lines_parse = false,
        },
      },
    },
    config = function(_, opts)
      require("colorizer").setup(opts)
    end,
  },

  { "chrisgrieser/nvim-origami", event = "BufReadPost", opts = {} },

  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    opts = {
      keymaps = {
        visual = "gs",
      },
    },
  },

  {
    "obsidian-nvim/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = false,
    ft = "markdown",
    dependencies = {
      -- required
      "nvim-lua/plenary.nvim",

      -- optional
      "saghen/blink.cmp",
      "folke/snacks.nvim",
      "nvim-treesitter/nvim-treesitter",
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          heading = {
            icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
            position = "inline",
            width = "block",
            left_pad = 2,
            right_pad = 2,
          },
          html = {
            comment = {
              conceal = false,
            },
          },
          checkbox = {
            enabled = true,
            custom = {
              todo = { raw = "[~]", rendered = " ", highlight = "RenderMarkdownTodo", scope_highlight = nil },
            },
          },
        },
      },
    },
    opts = {
      dir = vim.env.HOME .. "/obsidian-vault", -- specify the vault location. no need to call 'vim.fn.expand' here
      use_advanced_uri = true,
      picker = {
        -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', 'mini.pick' or 'snacks.pick'.
        name = "snacks.pick",
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

      -- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
      completion = {
        -- Enables completion using nvim_cmp
        nvim_cmp = false,
        -- Enables completion using blink.cmp
        blink = true,
        -- Trigger completion at 2 chars.
        min_chars = 2,
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
        -- Smart action depending on context: follow link, show notes with tag, or toggle checkbox.
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
          ["~"] = { char = " ", hl_group = "ObsidianTilde" },
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
      set({ "n", "v" }, "<leader>nd", "<Cmd>ObsidianDailies -7 7<CR>", { desc = "Obsidian daily" })
      set({ "n", "v" }, "<leader>ng", "<Cmd>ObsidianSearch<CR>", { desc = "Obsidian search" })
      set({ "n", "v" }, "<leader>nl", "<Cmd>ObsidianQuickSwitch<CR>", { desc = "Obsidian list" })
      set({ "n", "v" }, "<leader>nn", function()
        local input = vim.fn.input("File name: ")
        vim.cmd("ObsidianNewFromTemplate " .. input .. ".md")
      end, { desc = "Obsidian template" })
      set({ "n", "v" }, "<leader>no", "<cmd>ObsidianOpen<CR>", { desc = "Open current note in Obsidian app" })
      set({ "n", "v" }, "<leader>np", "<Cmd>ObsidianPasteImg<CR>", { desc = "Obsidian paste IMG" })
      set({ "n", "v" }, "<leader>nR", "<Cmd>ObsidianRename<CR>", { desc = "Obsidian rename file" })
      set({ "n", "v" }, "<leader>nt", "<Cmd>ObsidianToday<CR>", { desc = "Obsidian today" })
      set(
        { "n", "v" },
        "<leader>nr",
        "<Cmd>ObsidianBacklinks<CR>",
        { desc = "Obsidian find references to current buffer" }
      )
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
    "stevearc/quicker.nvim",
    event = "FileType qf",
    config = function()
      vim.keymap.set("n", "<leader>xq", function()
        require("quicker").toggle()
      end, {
        desc = "Quickfix List",
      })
      vim.keymap.set("n", "<leader>xl", function()
        require("quicker").toggle({ loclist = true })
      end, {
        desc = "Location List",
      })

      require("quicker").setup({
        -- Local options to set for quickfix
        opts = {
          buflisted = false,
          number = false,
          relativenumber = false,
          signcolumn = "auto",
          winfixheight = true,
          wrap = false,
        },
        -- Set to false to disable the default options in `opts`
        use_default_opts = true,
        -- Keymaps to set for the quickfix buffer
        keys = {
          {
            ">",
            function()
              require("quicker").expand({ before = 5, after = 5, add_to_existing = true })
            end,
            desc = "Expand quickfix context",
          },
          {
            "<",
            function()
              require("quicker").collapse()
            end,
            desc = "Collapse quickfix context",
          },
        },
        -- Callback function to run any custom logic or keymaps for the quickfix buffer
        on_qf = function(bufnr) end,
        edit = {
          -- Enable editing the quickfix like a normal buffer
          enabled = true,
          -- Set to true to write buffers after applying edits.
          -- Set to "unmodified" to only write unmodified buffers.
          autosave = "unmodified",
        },
        -- Keep the cursor to the right of the filename and lnum columns
        constrain_cursor = true,
        highlight = {
          -- Use treesitter highlighting
          treesitter = true,
          -- Use LSP semantic token highlighting
          lsp = true,
          -- Load the referenced buffers to apply more accurate highlights (may be slow)
          load_buffers = false,
        },
        follow = {
          -- When quickfix window is open, scroll to closest item to the cursor
          enabled = true,
        },
        -- Map of quickfix item type to icon
        type_icons = {
          E = "󰅚 ",
          W = "󰀪 ",
          I = " ",
          N = " ",
          H = " ",
        },
        -- Border characters
        borders = {
          vert = "│",
          -- Strong headers separate results from different files
          strong_header = "─",
          strong_cross = "┼",
          strong_end = "┤",
          -- Soft headers separate results within the same file
          soft_header = "┄",
          soft_cross = "┼",
          soft_end = "┤",
        },
        -- How to trim the leading whitespace from results. Can be 'all', 'common', or false
        trim_leading_whitespace = "common",
        -- Maximum width of the filename column
        max_filename_width = function()
          return math.floor(math.min(95, vim.o.columns / 2))
        end,
        -- How far the header should extend to the right
        header_length = function(type, start_col)
          return vim.o.columns - start_col
        end,
      })
    end,
  },

  {
    "folke/snacks.nvim",
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
      image = {
        enabled = false,
        doc = {
          inline = false,
          float = true,
        },
      },
      notifier = {
        top_down = false,
      },
      -- https://github.com/folke/snacks.nvim/blob/main/docs/picker.md#%EF%B8%8F-config
      picker = {
        layout = {
          preset = "ivy",
          cycle = false,
        },
        matcher = {
          frecency = true,
        },
        sources = {
          explorer = {
            auto_close = true,
            layout = { preset = "default", preview = true },
            win = {
              input = {
                keys = {
                  ["<c-\\>"] = "tcd",
                  ["<c-j>"] = { "preview_scroll_down", mode = { "i", "n" } },
                  ["<c-k>"] = { "preview_scroll_up", mode = { "i", "n" } },
                  ["<c-h>"] = { "preview_scroll_left", mode = { "i", "n" } },
                  ["<c-l>"] = { "preview_scroll_right", mode = { "i", "n" } },
                },
              },
              list = {
                keys = {
                  ["<c-/>"] = "terminal",
                  ["<c-\\>"] = "tcd",
                  ["<c-j>"] = { "preview_scroll_down", mode = { "i", "n" } },
                  ["<c-k>"] = { "preview_scroll_up", mode = { "i", "n" } },
                  ["<c-h>"] = { "preview_scroll_left", mode = { "i", "n" } },
                  ["<c-l>"] = { "preview_scroll_right", mode = { "i", "n" } },
                },
              },
            },
          },
        },
        win = {
          -- when focus is on input box above list
          input = {
            keys = {
              ["<Esc>"] = { "close", mode = { "n", "i" } }, -- close picker instead of going to normal mode
              ["<c-j>"] = { "preview_scroll_down", mode = { "i", "n" } },
              ["<c-k>"] = { "preview_scroll_up", mode = { "i", "n" } },
              ["<c-h>"] = { "preview_scroll_left", mode = { "i", "n" } },
              ["<c-l>"] = { "preview_scroll_right", mode = { "i", "n" } },
            },
          },
          -- when focus in on list
          list = {
            keys = {
              ["<c-j>"] = { "preview_scroll_down", mode = { "i", "n" } },
              ["<c-k>"] = { "preview_scroll_up", mode = { "i", "n" } },
              ["<c-h>"] = { "preview_scroll_left", mode = { "i", "n" } },
              ["<c-l>"] = { "preview_scroll_right", mode = { "i", "n" } },
            },
          },
        },
      },
      scroll = {
        enabled = false,
      },
      terminal = {
        win = {
          style = {
            border = "rounded",
          },
        },
      },
    },
  },

  {
    "arnamak/stay-centered.nvim",
    config = function()
      require("stay-centered").setup({
        -- The filetype is determined by the vim filetype, not the file extension. In order to get the filetype, open a file and run the command:
        -- :lua print(vim.bo.filetype)
        skip_filetypes = {},
        -- Set to false to disable by default
        enabled = true,
        -- allows scrolling to move the cursor without centering, default recommended
        allow_scroll_move = false,
        -- temporarily disables plugin on left-mouse down, allows natural mouse selection
        -- try disabling if plugin causes lag, function uses vim.on_key
        disable_on_mouse = true,
      })
    end,
  },

  {
    "gbprod/substitute.nvim",
    lazy = false,
    opts = {},
    config = function(_, opts)
      require("substitute").setup(opts)
      vim.keymap.set("n", "r", require("substitute").operator, { noremap = true })
      vim.keymap.set("x", "r", require("substitute").visual, { noremap = true })
      vim.keymap.set("n", "rr", require("substitute").line, { noremap = true })
      vim.keymap.set("n", "R", require("substitute").eol, { noremap = true })
    end,
  },

  {
    "Wansmer/symbol-usage.nvim",
    event = "LspAttach", -- need run before LspAttach if you use nvim 0.9. On 0.10 use 'LspAttach'
    config = function(_, opts)
      require("symbol-usage").setup(opts)
    end,
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
    config = function()
      vim.cmd([[let  g:tmux_navigator_no_wrap = 1]])
    end,
  },

  {
    "mg979/vim-visual-multi",
  },

  {
    "folke/which-key.nvim",
    opts = {
      preset = "classic",
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
      open_for_directories = true,
      keymaps = {
        show_help = "g?",
        open_file_in_horizontal_split = "<c-s>",
        open_file_in_vertical_split = "<c-v>",
        open_file_in_tab = "<c-t>",
        grep_in_directory = nil,
        replace_in_directory = "<c-g>",
        cycle_open_buffers = "<tab>",
        copy_relative_path_to_selected_files = "<c-y>",
        send_to_quickfix_list = "<c-q>",
        change_working_directory = "<c-\\>",
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

  {
    "LintaoAmons/scratch.nvim",
    cmd = { "Scratch", "ScratchWithName", "ScratchOpen", "ScratchOpenFzf" },
    keys = {
      { "<leader>Sn", "<cmd>Scratch<cr>", desc = "new scratch" },
      { "<leader>SN", "<cmd>ScratchWithName<cr>", desc = "new scratch (named)" },
      { "<leader>So", "<cmd>ScratchOpen<cr>", desc = "open scratch" },
      { "<leader>Sg", "<cmd>ScratchOpenFzf<cr>", desc = "open scratch (fzf)" },
    },
    opts = {
      filetypes = { "lua", "js", "sh", "ts" },
    },
  },
}
