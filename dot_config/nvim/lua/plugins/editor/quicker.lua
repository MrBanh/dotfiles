return {
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
        {
          "<localleader>r",
          function()
            require("quicker").refresh(nil, {
              keep_diagnostics = true,
            })
          end,
          desc = "Refresh quickfix list",
        },
        {
          "<localleader>>",
          function()
            -- prompt for number of lines to expand
            local num_of_lines = vim.fn.input("Num of Lines: ")

            require("quicker").expand({
              -- Convert input to number, default to 5 if empty
              before = tonumber(num_of_lines) or 5,
              after = tonumber(num_of_lines) or 5,
            })
          end,
          desc = "Expand by X number of lines",
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
}
