return {
  "esmuellert/codediff.nvim",
  cmd = "CodeDiff",
  keys = {

    { "<leader>gd", "", desc = "+Git Diff", mode = { "n", "v" } },
    {
      "<leader>gdd",
      ":CodeDiff<CR>",
      desc = "Git Diff",
      mode = { "n", "v" },
    },
    {
      "<leader>gdf",
      function()
        vim.fn.system("git rev-parse --verify main")
        local branch = vim.v.shell_error == 0 and "main" or "master"
        vim.cmd("CodeDiff file " .. branch .. "...")
      end,
      desc = "Git Diff Current File",
      mode = { "n", "v" },
    },
    {
      "<leader>gdh",
      ":CodeDiff history %<CR>",
      desc = "File History",
      mode = { "n", "v" },
    },
  },
  opts = {
    diff = {
      layout = "side-by-side", ---@type "inline" | "side-by-side"
    },

    explorer = {
      auto_open_on_cursor = true,
    },

    keymaps = {
      view = {
        close_on_open_in_prev_tab = true, -- Close codediff tab after gf opens file in previous tab
        toggle_explorer = "<localleader>e",
        focus_explorer = "<localleader>E",
        stage_hunk = "<localleader>s",
        unstage_hunk = "<localleader>u",
        discard_hunk = "<localleader>r",
      },
      conflict = {
        accept_incoming = "<localleader>ct",
        accept_current = "<localleader>co",
        accept_both = "<localleader>cb",
        discard = "<localleader>cx",
        accept_all_incoming = "<localleader>cT",
        accept_all_current = "<localleader>cO",
        accept_all_both = "<localleader>cB",
        discard_all = "<localleader>cX",
      },
    },
  },
}
