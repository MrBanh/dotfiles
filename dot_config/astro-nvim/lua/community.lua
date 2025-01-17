-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.completion.avante-nvim" },
  { import = "astrocommunity.completion.codeium-nvim" },
  { import = "astrocommunity.diagnostics.trouble-nvim" },
  { import = "astrocommunity.editing-support.nvim-treesitter-context" },
  { import = "astrocommunity.editing-support.undotree" },
  { import = "astrocommunity.editing-support.vim-visual-multi" },
  { import = "astrocommunity.game.leetcode-nvim" },
  { import = "astrocommunity.indent.indent-tools-nvim" },
  { import = "astrocommunity.lsp.inc-rename-nvim" },
  { import = "astrocommunity.lsp.lspsaga-nvim" },
  { import = "astrocommunity.markdown-and-latex.render-markdown-nvim" },
  { import = "astrocommunity.motion.harpoon" },
  { import = "astrocommunity.motion.nvim-surround" },
  { import = "astrocommunity.motion.tabout-nvim" },
  { import = "astrocommunity.neovim-lua-development.lazydev-nvim" },
  { import = "astrocommunity.note-taking.obsidian-nvim" }, -- ~/obsidian-vault
  { import = "astrocommunity.pack.chezmoi" },
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.markdown" },
  { import = "astrocommunity.pack.tailwindcss" },
  { import = "astrocommunity.pack.toml" },
  { import = "astrocommunity.project.project-nvim" },
  { import = "astrocommunity.recipes.auto-session-restore" },
  { import = "astrocommunity.recipes.disable-tabline" },
  { import = "astrocommunity.recipes.telescope-lsp-mappings" },
  { import = "astrocommunity.terminal-integration.vim-tmux-navigator" },
  { import = "astrocommunity.utility.hover-nvim" },
  { import = "astrocommunity.utility.noice-nvim" },
  { import = "astrocommunity.editing-support.nvim-origami" },
  { import = "astrocommunity.bars-and-lines.vim-illuminate" },
}
