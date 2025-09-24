-- Alternative:
--- https://github.com/magnusriga/markdown-tools.nvim
--- + https://github.com/artempyanykh/marksman

return {
  "obsidian-nvim/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = "markdown",
  cmd = {
    "ObsidianDailies",
    "ObsidianSearch",
    "ObsidianQuickSwitch",
    "Obsidian",
    "ObsidianOpen",
    "ObsidianPasteImg",
    "ObsidianRename",
    "ObsidianToday",
    "ObsidianBacklinks",
  },
  keys = {
    { "<leader>nd", ":ObsidianDailies -7 7<CR>", mode = { "n", "v" }, desc = "Obsidian daily" },
    { "<leader>ng", ":ObsidianSearch<CR>", mode = { "n", "v" }, desc = "Obsidian search" },
    { "<leader>nl", ":ObsidianQuickSwitch<CR>", mode = { "n", "v" }, desc = "Obsidian list" },
    { "<leader>nn", ":Obsidian new_from_template<CR>", mode = { "n", "v" }, desc = "Obsidian template" },
    { "<leader>no", ":ObsidianOpen<CR>", mode = { "n", "v" }, desc = "Open current note in Obsidian app" },
    { "<leader>np", ":ObsidianPasteImg<CR>", mode = { "n", "v" }, desc = "Obsidian paste IMG" },
    { "<leader>nR", ":ObsidianRename<CR>", mode = { "n", "v" }, desc = "Obsidian rename file" },
    { "<leader>nt", ":ObsidianToday<CR>", mode = { "n", "v" }, desc = "Obsidian today" },
    {
      "<leader>nr",
      ":ObsidianBacklinks<CR>",
      mode = { "n", "v" },
      desc = "Obsidian find references to current buffer",
    },
  },
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
    workspaces = {
      {
        name = "work",
        path = "~/obsidian-vault",
        overrides = {
          notes_subdir = "notes",
        },
      },
    },
    dir = vim.env.HOME .. "/obsidian-vault", -- specify the vault location. no need to call 'vim.fn.expand' here

    log_level = vim.log.levels.INFO,

    daily_notes = {
      folder = "Journal",
      date_format = "%Y-%m-%d (%a)",
      alias_format = "%B %-d, %Y",
      default_tags = { "daily-notes" },
      template = "daily-template.md",
      workdays_only = false, -- yesterday/tomorrow will return the previous/next work day
    },

    completion = {
      nvim_cmp = false,
      blink = true,
      min_chars = 2,
      create_new = true, -- false to disable new note creation in the picker
    },

    new_notes_location = "notes_subdir", -- "current_dir" (same buffer) or "notes_subdir" (default notes subdirectory)

    -- Optional, customize how note IDs are generated given an optional title.
    note_id_func = function(title)
      if title == nil then
        title = vim.fn.input("Note title: ")
      end

      local name = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      return name -- "Hulk Hogan" → "hulk-hogan"
    end,

    -- Optional, customize how note file names are generated given the ID, target directory, and title.
    ---@param spec { id: string, dir: obsidian.Path, title: string|? }
    ---@return string|obsidian.Path The full path to the new note.
    note_path_func = function(spec)
      local path = spec.dir / tostring(spec.id)
      return path:with_suffix(".md")
    end,

    -- Optional, customize how wiki links are formatted. You can set this to one of:
    -- _ "use_alias_only", e.g. '[[Foo Bar]]'
    -- _ "prepend*note_id", e.g. '[[foo-bar|Foo Bar]]'
    -- * "prepend*note_path", e.g. '[[foo-bar.md|Foo Bar]]'
    -- * "use_path_only", e.g. '[[foo-bar.md]]'
    -- Or you can set it to a function that takes a table of options and returns a string, like this:
    wiki_link_func = function(opts)
      return require("obsidian.util").wiki_link_id_prefix(opts)
    end,

    -- Optional,customize how markdown links are formatted.
    markdown_link_func = function(opts)
      return require("obsidian.util").markdown_link(opts)
    end,

    preferred_link_style = "wiki", -- 'wiki' or 'markdown'

    -- Optional, boolean or a function that takes a filename and returns a boolean.
    -- `true` indicates that you don't want obsidian.nvim to manage frontmatter.
    disable_frontmatter = false,

    -- Optional, alternatively you can customize the frontmatter data.
    ---@return table
    note_frontmatter_func = function(note)
      -- Add the title of the note as an alias.
      if note.title then
        note:add_alias(note.title)
      end

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

    -- Optional, for templates (see https://github.com/obsidian-nvim/obsidian.nvim/wiki/Using-templates)
    templates = {
      folder = "templates",
      date_format = "%Y-%m-%d-%a",
      time_format = "%H:%M",
      -- A map for custom variables, the key should be the variable and the value a function.
      -- Functions are called with obsidian.TemplateContext objects as their sole parameter.
      -- See: https://github.com/obsidian-nvim/obsidian.nvim/wiki/Template#substitutions
      substitutions = {},

      -- A map for configuring unique directories and paths for specific templates
      --- See: https://github.com/obsidian-nvim/obsidian.nvim/wiki/Template#customizations
      customizations = {
        ["daily-template"] = {
          notes_subdir = "Journal",
        },
        ["project-template"] = {
          notes_subdir = "Projects",
        },
        ["rfc-template"] = {
          notes_subdir = "RFCs",
        },
        ["topic-template"] = {
          notes_subdir = "Topics",
        },
      },
    },

    follow_url_func = function(url)
      vim.ui.open(url)
      -- vim.ui.open(url, { cmd = { "firefox" } })
    end,

    follow_img_func = function(img)
      vim.ui.open(img)
      -- vim.ui.open(img, { cmd = { "loupe" } })
    end,

    open = {
      use_advanced_uri = false, -- Opens the file with current line number
      func = vim.ui.open, -- Function to do the opening
    },

    picker = {
      name = "snacks.pick", -- telescope.nvim, fzf-lua, mini.pick, snacks.pick
      -- Not all pickers support all mappings.
      note_mappings = {
        new = "<C-x>", -- Create a new note from the current query.
        insert_link = "<C-l>", -- Insert a link to the selected note
      },
      tag_mappings = {
        tag_note = "<C-x>", -- Add tag(s) to the current note.
        insert_tag = "<C-l>", -- Insert a tag at the current location.
      },
    },

    backlinks = {
      parse_headers = true,
    },

    -- Sort search results
    sort_by = "modified", -- "path", "modified", "accessed", "created"
    sort_reversed = true, -- show notes by latest _

    -- 1. "current" (the default) - to always open in the current window
    -- 2. "vsplit" - only open in a vertical split if a vsplit does not exist.
    -- 3. "hsplit" - only open in a horizontal split if a hsplit does not exist.
    -- 4. "vsplit_force" - always open a new vertical split if the file is not in the adjacent vsplit.
    -- 5. "hsplit_force" - always open a new horizontal split if the file is not in the adjacent hsplit.
    open_notes_in = "current",

    -- Optional, define your own callbacks to further customize behavior.
    callbacks = {
      -- Runs at the end of `require("obsidian").setup()`.
      ---@param client obsidian.Client
      post_setup = function(client) end,

      -- Runs anytime you enter the buffer for a note.
      ---@param client obsidian.Client
      ---@param note obsidian.Note
      enter_note = function(client, note) end,

      -- Runs anytime you leave the buffer for a note.
      ---@param client obsidian.Client
      ---@param note obsidian.Note
      leave_note = function(client, note) end,

      -- Runs right before writing the buffer for a note.
      ---@param client obsidian.Client
      ---@param note obsidian.Note
      pre_write_note = function(client, note) end,

      -- Runs anytime the workspace is set/changed.
      ---@param client obsidian.Client
      ---@param workspace obsidian.Workspace
      -- post_set_workspace = function(client, workspace) end,
    },

    -- requires `conceallevel` to be set to 1 or 2
    ui = {
      enable = false, -- md ui handled by render-markdown.nvim      ignore_conceal_warn = false, -- set to true to disable conceallevel specific warning
    },
    checkbox = {
      order = { " ", "~", "x" },
    },

    footer = {
      enabled = false,
      format = "{{backlinks}} backlinks  {{properties}} properties  {{words}} words  {{chars}} chars",
      hl_group = "Comment",
      separator = string.rep("-", 80),
    },
  },

  config = function(_, opts)
    require("obsidian").setup(opts)
  end,
}
