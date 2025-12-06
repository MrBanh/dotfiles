local keymap_prefix = "<leader>a"

return {
  "sudo-tee/opencode.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MeanderingProgrammer/render-markdown.nvim",
    "saghen/blink.cmp",
    "folke/snacks.nvim",
  },
  config = function()
    require("opencode").setup({
      keymap_prefix = keymap_prefix, -- Default keymap prefix for global keymaps change to your preferred prefix and it will be applied to all keymaps starting with <leader>o
      keymap = {
        editor = {
          ["<leader>og"] = false,
          ["<leader>oa"] = { "toggle" }, -- Open opencode. Close if opened

          ["<leader>ot"] = false,
          ["<leader>of"] = { "toggle_focus" }, -- Toggle focus between opencode and last window
        },
        input_window = {
          ["<cr>"] = false,
          ["<C-s>"] = { "submit_input_prompt", mode = { "n", "i" } }, -- Submit prompt (normal mode and insert mode)

          ["q"] = { "close", mode = { "n" } }, -- Close UI windows
          ["<M-w>"] = { "toggle_pane", mode = { "n", "i" } }, -- Toggle between input and output panes
          ["<tab>"] = { "switch_mode" }, -- Switch between modes (build/plan)
        },
        output_window = {
          ["q"] = { "close" }, -- Close UI windows
          ["<M-w>"] = { "toggle_pane", mode = { "n", "i" } }, -- Toggle between input and output panes
        },
      },
    })

    -- <M-/> does not work when passed into keymap config
    vim.keymap.set({ "n", "t", "i", "x" }, "<M-/>", function()
      require("opencode.api").toggle()
    end, { desc = "Opencode Toggle" })
    vim.keymap.set({ "n", "v" }, keymap_prefix .. "r", "", { desc = "+revert" })
    vim.keymap.set({ "n", "v" }, keymap_prefix .. "P", "", { desc = "+permissions" })
  end,
}
