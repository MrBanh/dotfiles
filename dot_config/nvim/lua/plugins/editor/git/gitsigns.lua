return {
  "lewis6991/gitsigns.nvim",
  opts = {
    current_line_blame = true,
  },
  config = function(_, opts)
    local default_on_attach = opts.on_attach

    opts.on_attach = function(buffer)
      default_on_attach(buffer)

      -- if I need to override keys: https://github.com/LazyVim/LazyVim/discussions/4790
      local gs = package.loaded.gitsigns

      vim.keymap.set("n", "]H", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gs.nav_hunk("next", { target = "all" })
        end
      end, { desc = "Next Hunk (all)", buffer = buffer })

      vim.keymap.set("n", "[H", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gs.nav_hunk("prev", { target = "all" })
        end
      end, { desc = "Prev Hunk (all)", buffer = buffer })
    end

    require("gitsigns").setup(opts)

    Snacks.toggle({
      name = "Git Inline Blame",
      get = function()
        return require("gitsigns.config").config.current_line_blame
      end,
      set = function()
        require("gitsigns").toggle_current_line_blame()
      end,
    }):map("<leader>uB")
  end,
}
