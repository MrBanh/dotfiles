local treeutils = require "utils.nvim-tree-utils"

local HEIGHT_RATIO = 1
local WIDTH_RATIO = 0.5
local screen_w = vim.opt.columns:get()
local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
local window_w = screen_w * WIDTH_RATIO
local window_h = screen_h * HEIGHT_RATIO
local window_w_int = math.floor(window_w)
local window_h_int = math.floor(window_h)
local center_x = screen_w -- (screen_w - window_w) / 2
local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()

return {
  {
    "b0o/nvim-tree-preview.lua",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- "3rd/image.nvim", -- Optional, for previewing images
    },
    config = function()
      require("nvim-tree-preview").setup {
        keymaps = {
          ["<Esc>"] = { action = "close", unwatch = true },
          ["<Tab>"] = { action = "toggle_focus" },
          ["<CR>"] = { open = "edit" },
          ["<C-t>"] = { open = "tab" },
          ["<C-v>"] = { open = "vertical" },
          ["<C-x>"] = { open = "horizontal" },
          ["<C-n>"] = { action = "select_node", target = "next" },
          ["<C-p>"] = { action = "select_node", target = "prev" },
        },
        min_width = 10,
        min_height = 5,
        max_width = 85,
        max_height = 25,
        wrap = false, -- Whether to wrap lines in the preview window
        border = "rounded", -- Border style for the preview window
        zindex = 100, -- Stacking order. Increase if the preview window is shown below other windows.
        show_title = true, -- Whether to show the file name as the title of the preview window
        title_pos = "top-center", -- top-left|top-center|top-right|bottom-left|bottom-center|bottom-right
        title_format = " %s ",
        follow_links = true, -- Whether to follow symlinks when previewing files
        image_preview = {
          enable = false, -- Whether to preview images (for more info see Previewing Images section in README)
          patterns = { -- List of Lua patterns matching image file names
            ".*%.png$",
            ".*%.jpg$",
            ".*%.jpeg$",
            ".*%.gif$",
            ".*%.webp$",
            ".*%.avif$",
            -- Additional patterns:
            -- '.*%.svg$',
            -- '.*%.bmp$',
            -- '.*%.pdf$', (known to have issues)
          },
        },
        on_open = nil, -- fun(win: number, buf: number) called when the preview window is opened
        on_close = nil, -- fun() called when the preview window is closed
      }
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      {
        "b0o/nvim-tree-preview.lua",
        dependencies = {
          "nvim-lua/plenary.nvim",
          -- "3rd/image.nvim", -- Optional, for previewing images
        },
      },
    },
    opts = {
      live_filter = {
        prefix = "[FILTER]: ",
        always_show_folders = false, -- Turn into false from true by default
      },
      view = {
        adaptive_size = true,
        side = "right",
        float = {
          enable = true,
          open_win_config = function()
            return {
              border = "rounded",
              relative = "editor",
              row = center_y,
              col = center_x,
              width = window_w_int,
              height = window_h_int,
            }
          end,
        },
      },
      on_attach = function(bufnr)
        local api = require "nvim-tree.api"

        -- Important: When you supply an `on_attach` function, nvim-tree won't
        -- automatically set up the default keymaps. To set up the default keymaps,
        -- call the `default_on_attach` function. See `:help nvim-tree-quickstart-custom-mappings`.
        api.config.mappings.default_on_attach(bufnr)

        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        -- Automatically open file on creation
        api.events.subscribe(api.events.Event.FileCreated, function(file)
          vim.cmd("edit " .. vim.fn.fnameescape(file.fname))
        end)

        local preview = require "nvim-tree-preview"
        vim.keymap.set("n", "P", preview.watch, opts "Preview (Watch)")
        vim.keymap.set("n", "<Esc>", preview.unwatch, opts "Close Preview/Unwatch")
        vim.keymap.set("n", "<C-d>", function()
          return preview.scroll(4)
        end, opts "Scroll Down")
        vim.keymap.set("n", "<C-u>", function()
          return preview.scroll(-4)
        end, opts "Scroll Up")

        -- Option A: Smart tab behavior: Only preview files, expand/collapse directories (recommended)
        vim.keymap.set("n", "<Tab>", function()
          local ok, node = pcall(api.tree.get_node_under_cursor)
          if ok and node then
            if node.type == "directory" then
              api.node.open.edit()
            else
              preview.node(node, { toggle_focus = true })
            end
          end
        end, opts "Preview")

        -- Option B: Simple tab behavior: Always preview
        -- vim.keymap.set('n', '<Tab>', preview.node_under_cursor, opts 'Preview')

        vim.keymap.set("n", "<c-f>", treeutils.launch_find_files, opts "Launch Find Files")
        vim.keymap.set("n", "<c-g>", treeutils.launch_live_grep, opts "Launch Live Grep")
        vim.keymap.set("n", "ga", treeutils.git_add, opts "Git Add")
        vim.keymap.set("n", "<C-c>", treeutils.change_root_to_global_cwd, opts "Change Root To Global CWD")
      end,
    },
    keys = {
      {
        "<leader>e",
        ":NvimTreeToggle<CR>",
        mode = { "n" },
        desc = "Toggle explorer",
      },
    },
  },
}
