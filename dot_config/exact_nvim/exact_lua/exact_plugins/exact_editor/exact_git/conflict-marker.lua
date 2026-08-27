return {
  "tronikelis/conflict-marker.nvim",
  lazy = false,
  opts = {
    on_attach = function(conflict)
      local function map(key, fn)
        vim.keymap.set("n", key, fn, { buffer = conflict.bufnr })
      end

      local MID = "^=======$"

      map("[x", function()
        vim.cmd("?" .. MID)
      end)

      map("]x", function()
        vim.cmd("/" .. MID)
      end)

      -- Repaint after resolving. The choose_* methods delete lines but never
      -- touch the highlight namespace, and the CursorMoved refresh only clears a
      -- region while the cursor is inside a still-valid conflict. Once the markers
      -- are gone that cleanup path early-returns, so stale highlights linger until
      -- the buffer is reopened. refresh_hl_all does a full clear + rescan.
      local function choose(method)
        return function()
          conflict[method](conflict)
          conflict:refresh_hl_all()
        end
      end

      map("co", choose("choose_ours"))
      map("ct", choose("choose_theirs"))
      map("cb", choose("choose_both"))
      map("cn", choose("choose_none"))
    end,
  },
}
