-- Alternative:
--- https://github.com/magnusriga/markdown-tools.nvim
--- + https://github.com/artempyanykh/marksman

return {
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>n", group = "Notes/New...", icon = { icon = "󰎝 ", color = "purple", cat = "extension" } },
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
      "MeanderingProgrammer/render-markdown.nvim",
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
}
