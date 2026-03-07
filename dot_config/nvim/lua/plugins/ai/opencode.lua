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
  opts = {
    keymap_prefix = keymap_prefix, -- Default keymap prefix for global keymaps change to your preferred prefix and it will be applied to all keymaps starting with <leader>o
    keymap = {
      editor = {
        ["<leader>oq"] = false,

        ["<leader>og"] = false,
        ["<leader>oa"] = { "toggle" }, -- Open opencode. Close if opened

        ["<leader>ot"] = false,
        ["<leader>of"] = { "toggle_focus" }, -- Toggle focus between opencode and last window

        -- Diff
        ["<leader>od"] = false,
        ["<leader>odd"] = { "diff_open", desc = "Open diff view" },
        ["<leader>o]"] = false,
        ["<leader>od]"] = { "diff_next", desc = "Next diff" },
        ["<leader>o["] = false,
        ["<leader>od["] = { "diff_prev", desc = "Previous diff" },
        ["<leader>oc"] = false,
        ["<leader>odq"] = { "diff_close", desc = "Close diff view" },

        -- Configure providers & variants
        ["<leader>op"] = false,
        ["<leader>ocp"] = { "configure_provider", desc = "Configure provider" },
        ["<leader>oV"] = false,
        ["<leader>ocv"] = { "configure_variant", desc = "Configure variant" },

        -- Sessions
        ["<leader>oI"] = false,
        ["<leader>osn"] = { "open_input_new_session", desc = "Open input (new session)" },
        ["<leader>os"] = false,
        ["<leader>oss"] = { "select_session", desc = "Select and load a session" },
        ["<leader>oR"] = false,
        ["<leader>osr"] = { "rename_session", desc = "Rename current session" },
        ["<leader>oT"] = false,
        ["<leader>ost"] = { "timeline", desc = "Session timeline" }, -- Display timeline picker to navigate/undo/redo/fork messages

        -- Mentions
        ["<leader>@/"] = { "quick_chat", mode = { "n", "x" } },
        ["<leader>@v"] = { "paste_image" },
        ["<leader>@y"] = { "add_visual_selection", mode = { "v" } },

        -- Toggle
        ["<leader>ox"] = false,
        ["<leader>otx"] = { "swap_position", desc = "Toggle Opencode pane left/right" },
        ["<leader>oz"] = false,
        ["<leader>otz"] = { "toggle_zoom", desc = "Toggle Zoom in/out on the Opencode windows" },
      },
      input_window = {
        ["~"] = false,
        ["<cr>"] = false,
        ["<S-cr>"] = false,
        ["<M-v>"] = false,
        ["<M-m>"] = false,
        ["<M-r>"] = false,

        ["q"] = { "close", mode = { "n" } }, -- Close UI windows
        ["<C-c>"] = { "close" },
        ["<esc>"] = { "cancel" },

        ["@f"] = { "mention_file", mode = { "n", "i" } }, -- Pick a file and add to context.
        ["@v"] = { "paste_image", mode = { "n", "i" }, desc = "Paste image from clipboard" },

        ["<tab>"] = { "switch_mode", mode = { "n", "v", "i" } }, -- build/plan
        ["<C-t>"] = { "cycle_variant", mode = { "n", "v", "i" } }, -- model variants
        ["<C-n>"] = { "next_prompt_history", mode = { "n", "i" } }, -- Navigate to next prompt in history
        ["<C-p>"] = { "prev_prompt_history", mode = { "n", "i" } }, -- Navigate to previous prompt in history
        ["<C-s>"] = { "submit_input_prompt", mode = { "n", "i" } }, -- Submit prompt (normal mode and insert mode)
      },
      output_window = {
        ["q"] = { "close" }, -- Close UI windows
        ["<C-c>"] = { "close" },
        ["<esc>"] = { "cancel" },

        ["<tab>"] = { "switch_mode", mode = { "n", "v" } },
        ["<C-t>"] = { "cycle_variant", mode = { "n", "v" } },
      },
      session_picker = {
        delete_session = { "<C-x>" }, -- Delete selected session in the session picker
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
  },
  config = function(_, opts)
    require("opencode").setup(opts)

    -- <M-/> does not work when passed into keymap config
    vim.keymap.set({ "n", "t", "i", "x" }, "<M-/>", function()
      require("opencode.api").toggle()
    end, { desc = "Opencode Toggle" })

    vim.keymap.set({ "n", "v" }, "<leader>@", "", { desc = "+ai mentions" })
    vim.keymap.set({ "n", "v" }, keymap_prefix .. "c", "", { desc = "+configure models" })
    vim.keymap.set({ "n", "v" }, keymap_prefix .. "d", "", { desc = "+diff" })
    vim.keymap.set({ "n", "v" }, keymap_prefix .. "r", "", { desc = "+revert" })
    vim.keymap.set({ "n", "v" }, keymap_prefix .. "s", "", { desc = "+session management" })
    vim.keymap.set({ "n", "v" }, keymap_prefix .. "t", "", { desc = "+toggle" })
  end,
}
