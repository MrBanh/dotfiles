if not vim.g.vscode then
  return {}
end

-- Options

vim.cmd("au BufEnter * au! BufModifiedSet")

-- Plugins

local enabled = {
  "LazyVim",
  "dial.nvim",
  "flit.nvim",
  "lazy.nvim",
  "leap.nvim",
  "mini.ai",
  "mini.comment",
  "mini.move",
  "mini.pairs",
  "mini.surround",
  "nvim-treesitter",
  "nvim-treesitter-textobjects",
  "nvim-ts-context-commentstring",
  "snacks.nvim",
  "ts-comments.nvim",
  "vim-repeat",
  "yanky.nvim",
  "substitute.nvim",
  "nvim-surround",
}

local Config = require("lazy.core.config")
Config.options.checker.enabled = false
Config.options.change_detection.enabled = false
Config.options.defaults.cond = function(plugin)
  return vim.tbl_contains(enabled, plugin.name) or plugin.vscode
end
vim.g.snacks_animate = false

-- Add some vscode specific keymaps
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyVimKeymapsDefaults",
  callback = function()
    local set = vim.keymap.set
    local opts = { noremap = true, silent = true }
    local vscode = require("vscode")

    -- LSP
    set({ "n" }, "gI", function()
      vscode.action("editor.action.goToImplementation")
    end, opts)
    set({ "n" }, "gd", function()
      vscode.action("editor.action.revealDefinition")
    end, opts)
    set({ "n" }, "gD", function()
      vscode.action("editor.action.revealDeclaration")
    end, opts)
    set({ "n" }, "gr", function()
      vscode.action("editor.action.goToReferences")
    end, opts)
    set({ "n" }, "gy", function()
      vscode.action("editor.action.goToTypeDefinition")
    end, opts)

    -- diagnostics
    set({ "n" }, "]d", function()
      vscode.call("editor.action.marker.next")
    end)
    set({ "n" }, "[d", function()
      vscode.call("editor.action.marker.prev")
    end)

    -- git changes
    set({ "n" }, "]h", function()
      vscode.call("workbench.action.editor.nextChange")
    end, opts)
    set({ "n" }, "[h", function()
      vscode.call("workbench.action.editor.previousChange")
    end, opts)

    -- Fold/Unfold
    set("n", "zM", function()
      vscode.action("editor.foldAll")
    end, opts)

    set("n", "zR", function()
      vscode.action("editor.unfoldAll")
    end, opts)

    set("n", "zc", function()
      vscode.action("editor.fold")
    end, opts)

    set("n", "zC", function()
      vscode.action("editor.foldRecursively")
    end, opts)

    set("n", "zo", function()
      vscode.action("editor.unfold")
    end, opts)

    set("n", "zO", function()
      vscode.action("editor.unfoldRecursively")
    end, opts)

    set("n", "za", function()
      vscode.action("editor.toggleFold")
    end, opts)
  end,
})

function LazyVim.terminal()
  require("vscode").action("workbench.action.terminal.toggleTerminal")
end

-- plugins and/or plugins' settings specifically for vscode
return {
  {
    "snacks.nvim",
    opts = {
      bigfile = { enabled = false },
      dashboard = { enabled = false },
      explorer = { enabled = false },
      indent = { enabled = false },
      input = { enabled = false },
      picker = { enabled = false },
      notifier = { enabled = false },
      quickfile = { enabled = false },
      scope = { enabled = false },
      scroll = { enabled = false },
      statuscolumn = { enabled = false },
      words = { enabled = false },
    },
  },
  {
    "LazyVim/LazyVim",
    config = function(_, opts)
      opts = opts or {}
      -- disable the colorscheme
      opts.colorscheme = function() end
      require("lazyvim").setup(opts)
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { highlight = { enable = false } },
  },
  {
    "vscode-neovim/vscode-multi-cursor.nvim",
    lazy = false,
    event = "VeryLazy",
    cond = not not vim.g.vscode,
    opts = {
      default_mappings = false,
    },
    config = function(_, opts)
      require("vscode-multi-cursor").setup(opts)

      vim.keymap.set(
        { "n", "x", "i" },
        "<C-m>",
        require("vscode-multi-cursor").addSelectionToNextFindMatch,
        { noremap = true }
      )
    end,
  },
}
