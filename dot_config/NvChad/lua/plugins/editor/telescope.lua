require("which-key").add { "<leader>f", group = "Find" }
require("which-key").add { "<leader>s", group = "Search" }

local build_cmd ---@type string?
for _, cmd in ipairs { "make", "cmake", "gmake" } do
  if vim.fn.executable(cmd) == 1 then
    build_cmd = cmd
    break
  end
end

local actions = require "telescope.actions"
local builtin = require "telescope.builtin"

return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "gbprod/yanky.nvim",
    },
    opts = {
      -- https://github.com/nvim-telescope/telescope.nvim/blob/b4da76be54691e854d3e0e02c36b0245f945c2c7/lua/telescope/mappings.lua#L133
      defaults = {
        mappings = {
          i = {
            ["<C-s>"] = actions.select_horizontal,
            ["<C-x>"] = function(...)
              actions.delete_buffer(...)
            end,
          },
          n = {
            ["<C-s>"] = actions.select_horizontal,
            ["<C-x>"] = function(...)
              actions.delete_buffer(...)
            end,
          },
        },
      },
      -- https://github.com/nvim-telescope/telescope.nvim/wiki/Extensions
      extensions = {
        fzf = {
          fuzzy = true, -- false will only do exact matching
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true, -- override the file sorter
          case_mode = "smart_case", -- or "ignore_case" or "respect_case"
        },
      },
    },
    config = function(_, opts)
      require("telescope").setup(opts)

      -- extensions
      require("telescope").load_extension "fzf"
      require("telescope").load_extension "ui-select"
      require("telescope").load_extension "yank_history"

      local set = vim.keymap.set

      set("n", "<leader>/", "<cmd>Telescope live_grep<CR>", { desc = "live grep", remap = true })
      set("n", "<leader>:", "<cmd>Telescope command_history<CR>", { desc = "Command history" })
      set("n", "<leader><space>", "<cmd>Telescope find_files<cr>", { desc = "Find files" })

      -- Find in current workspace
      set(
        "n",
        "<leader>fa",
        "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
        { desc = "Find all files" }
      )
      set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Buffers" })
      set("n", "<leader>fd", "<cmd>Telescope diagnostics bufnr=0<CR>", { desc = "Document diagnostics" })
      set("n", "<leader>fD", "<cmd>Telescope diagnostics<CR>", { desc = "Workspace diagnostics" })
      set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Files" })
      set("n", "<leader>fj", "<cmd>Telescope jumplist<CR>", { desc = "Jumplist" })
      set("n", "<leader>fl", "<cmd>Telescope loclist<CR>", { desc = "Location list" })
      set("n", "<leader>fm", "<cmd>Telescope marks<CR>", { desc = "Marks" })
      set("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "Old files" })
      set("n", "<leader>fR", "<cmd>Telescope resume<CR>", { desc = "Resumt" })
      set("n", "<leader>fq", "<cmd>Telescope quickfix<CR>", { desc = "Quickfix" })
      set("n", "<leader>fs", function()
        builtin.lsp_document_symbols()
      end, {
        desc = "Goto Symbol",
      })
      set("n", "<leader>fS", function()
        builtin.lsp_dynamic_workspace_symbols()
      end, {
        desc = "Goto Symbol (Workspace)",
      })
      set("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "live grep" })
      set("v", "<leader>fw", "<cmd>Telescope grep_string<CR>", { desc = "live grep word" })
      set("n", "<leader>fW", "<cmd>Telescope grep_string<CR>", { desc = "live grep word" })
      set("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "Find in current buffer" })

      -- Git
      set("n", "<leader>fg", "<cmd>Telescope git_files<CR>", { desc = "Find git files" })
      set("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", { desc = "Git Commits" })
      set("n", "<leader>gs", "<cmd>Telescope git_status<CR>", { desc = "Git Status" })

      -- Search (external)
      require("which-key").add { "<leader>s", group = "Search" }
      set("n", "<leader>sa", "<cmd>Telescope autocommands<CR>", { desc = "Autocommands" })
      set("n", "<leader>sc", "<cmd>Telescope command_history<CR>", { desc = "Command history" })
      set("n", "<leader>sC", "<cmd>Telescope commands<CR>", { desc = "Commands" })
      set("n", "<leader>sh", "<cmd>Telescope help_tags<CR>", { desc = "Help pages" })
      set("n", "<leader>sH", "<cmd>Telescope highlights<CR>", { desc = "Highlight groups" })
      set("n", "<leader>sk", "<cmd>Telescope keymaps<CR>", { desc = "Keymaps" })
      set("n", "<leader>sm", "<cmd>Telescope man_pages<CR>", { desc = "Man pages" })
      set("n", "<leader>so", "<cmd>Telescope vim_options<CR>", { desc = "Options" })
      set("n", "<leader>sr", "<cmd>Telescope registers<CR>", { desc = "Registers" })

      -- LSP
      set("n", "gd", function()
        builtin.lsp_definitions { reuse_win = true }
      end, { desc = "Goto Definition" })
      set("n", "gr", "<cmd>Telescope lsp_references<cr>", { desc = "References", nowait = true })
      set("n", "gI", function()
        builtin.lsp_implementations { reuse_win = true }
      end, { desc = "Goto Implementation" })
      set("n", "gy", function()
        builtin.lsp_type_definitions { reuse_win = true }
      end, { desc = "Goto T[y]pe Definition" })
    end,
  },

  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = (build_cmd ~= "cmake") and "make"
      or "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
  },
}
