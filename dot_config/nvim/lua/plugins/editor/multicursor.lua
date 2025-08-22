return {
  "jake-stewart/multicursor.nvim",
  config = function()
    require("which-key").add({
      "<leader>m",
      group = "MultiCursor",
      icon = { icon = "󰆿 " },
    })

    local mc = require("multicursor-nvim")
    mc.setup()

    local set = vim.keymap.set

    -- Add a cursor for all matches of cursor word/selection in the document.
    set({ "n", "x" }, "<leader>mA", mc.matchAllAddCursors, { desc = "Add Cursors to all cursor word" })

    -- bring back cursors if you accidentally clear them
    set("n", "<leader>mv", mc.restoreCursors, { desc = "Restore Cursors" })

    -- Disable and enable cursors.
    set({ "n", "x" }, "<leader>mt", mc.toggleCursor, { desc = "Toggle Cursors" })

    -- Split visual selections by regex.
    set("x", "<leader>m!", mc.splitCursors, { desc = "Split Visual Selection by Regex" })

    -- match new cursors within visual selections by regex.
    set("x", "<leader>m%", mc.matchCursors, { desc = "Add cursors to matched regex in Visual Selection" })

    -- Add a cursor to every search result in the buffer.
    set("n", "<leader>m/", mc.searchAllAddCursors, { desc = "Add Cursors to Search Results in buffer from /" })

    -- Append/insert for each line of visual selections.
    set("x", "I", mc.insertVisual, { desc = "Insert cursor at start of each line in Visual Selection" })
    set("x", "A", mc.appendVisual, { desc = "Append cursor at end of each line in Visual Selection" })

    -- Add or skip adding a new cursor by matching word/selection
    set({ "n", "x" }, "<C-n>", function()
      mc.matchAddCursor(1)
    end, { desc = "Add Cursor at next match" })
    set({ "n", "x" }, "<C-p>", function()
      mc.matchAddCursor(-1)
    end, { desc = "Add Cursor at previous match" })

    -- skip match
    set({ "n", "x" }, "<leader>mn", function()
      mc.matchSkipCursor(1)
    end, { desc = "Skip next match" })
    set({ "n", "x" }, "<leader>mp", function()
      mc.matchSkipCursor(-1)
    end, { desc = "Skip previous match" })

    -- Mappings defined in a keymap layer only apply when there are
    -- multiple cursors. This lets you have overlapping mappings.
    mc.addKeymapLayer(function(layerSet)
      -- select next/previous cursor
      layerSet({ "n", "x" }, "n", mc.nextCursor, { desc = "Select Next Cursor" })
      layerSet({ "n", "x" }, "N", mc.prevCursor, { desc = "Select Previous Cursor" })

      -- add line above/below
      layerSet({ "n", "x" }, "<up>", function()
        mc.lineAddCursor(-1)
      end, { desc = "Add Cursor above" })
      layerSet({ "n", "x" }, "<down>", function()
        mc.lineAddCursor(1)
      end, { desc = "Add Cursor below" })

      -- skip line above/below
      layerSet({ "n", "x" }, "<S-Up>", function()
        mc.lineSkipCursor(-1)
      end, { desc = "Skip Cursor above" })
      layerSet({ "n", "x" }, "<S-down>", function()
        mc.lineSkipCursor(1)
      end, { desc = "Skip Cursor below" })

      -- sequentual increment/decrement
      layerSet({ "n", "x" }, "g<c-a>", mc.sequenceIncrement, {
        desc = "Increment",
      })
      layerSet({ "n", "x" }, "g<c-x>", mc.sequenceDecrement, {
        desc = "Decrement",
      })

      -- align
      layerSet({ "n", "x" }, "|", mc.alignCursors, { desc = "Align Cursors" })

      -- delete
      layerSet({ "n", "x" }, "<C-x>", mc.deleteCursor, { desc = "Delete Cursor" })

      layerSet("n", "<esc>", function()
        if not mc.cursorsEnabled() then
          mc.enableCursors()
        else
          mc.clearCursors()
        end
      end, { desc = "Enable/clear cursors" })
    end)

    -- Customize how cursors look.
    local hl = vim.api.nvim_set_hl
    hl(0, "MultiCursorCursor", { reverse = true })
    hl(0, "MultiCursorVisual", { link = "Visual" })
    hl(0, "MultiCursorSign", { link = "SignColumn" })
    hl(0, "MultiCursorMatchPreview", { link = "Search" })
    hl(0, "MultiCursorDisabledCursor", { reverse = true })
    hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
    hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
  end,
}
