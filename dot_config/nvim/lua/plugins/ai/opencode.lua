local keymap_prefix = "<leader>a"

return {
  "sudo-tee/opencode.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "saghen/blink.cmp",
    "folke/snacks.nvim",
    { "MeanderingProgrammer/render-markdown.nvim", optional = true },
    { "OXY2DEV/markview.nvim", optional = true },
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
          ["~"] = false,

          ["q"] = { "close", mode = { "n" } }, -- Close UI windows
          ["<M-@>"] = { "mention_file", mode = { "n", "i" } }, -- Pick a file and add to context.
          ["<C-n>"] = { "next_prompt_history", mode = { "n", "i" } }, -- Navigate to next prompt in history
          ["<C-p>"] = { "prev_prompt_history", mode = { "n", "i" } }, -- Navigate to previous prompt in history
          ["<C-s>"] = { "submit_input_prompt", mode = { "n", "i" } }, -- Submit prompt (normal mode and insert mode)
        },
        output_window = {
          ["q"] = { "close" }, -- Close UI windows
        },
        session_picker = {
          delete_session = { "<C-x>" }, -- Delete selected session in the session picker
          new_session = { "<C-s>" }, -- Create and switch to a new session in the session picker
        },
        history_picker = {
          delete_entry = { "<C-x>", mode = { "i", "n" } }, -- Delete selected entry in the history picker
          clear_all = { "<C-d>", mode = { "i", "n" } }, -- Clear all entries in the history picker
        },
      },
      ui = {
        window_width = 0.50,
        input = {
          text = {
            wrap = false,
          },
        },
        picker = {
          snacks_layout = {
            preset = "select",
          },
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
