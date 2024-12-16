-- Astro default plugins: https://docs.astronvim.com/reference/default_plugins/#_top
-- Astro default plugins' configuration files: https://github.com/AstroNvim/AstroNvim/tree/main/lua%2Fastronvim%2Fplugins
-- Docs on customizing plugins: https://docs.astronvim.com/configuration/customizing_plugins/

return {

  -- heirline: statusline, winbar, tabline, etc
  -- https://github.com/rebelot/heirline.nvim/tree/master
  {
    "rebelot/heirline.nvim",
    opts = function(_, opts)
      local status = require "astroui.status"
      local path_func = status.provider.filename { modify = ":.:h", fallback = "" }

      -- https://github.com/rebelot/heirline.nvim/blob/master/cookbook.md#lsp
      opts.winbar = {
        condition = function() return require("nvim-navic").is_available() end,
        static = {
          -- create a type highlight map
          type_hl = {
            File = "Directory",
            Module = "@include",
            Namespace = "@namespace",
            Package = "@include",
            Class = "@structure",
            Method = "@method",
            Property = "@property",
            Field = "@field",
            Constructor = "@constructor",
            Enum = "@field",
            Interface = "@type",
            Function = "@function",
            Variable = "@variable",
            Constant = "@constant",
            String = "@string",
            Number = "@number",
            Boolean = "@boolean",
            Array = "@field",
            Object = "@type",
            Key = "@keyword",
            Null = "@comment",
            EnumMember = "@field",
            Struct = "@structure",
            Event = "@keyword",
            Operator = "@operator",
            TypeParameter = "@type",
          },
          -- bit operation dark magic, see below...
          enc = function(line, col, winnr) return bit.bor(bit.lshift(line, 16), bit.lshift(col, 6), winnr) end,
          -- line: 16 bit (65535); col: 10 bit (1023); winnr: 6 bit (63)
          dec = function(c)
            local line = bit.rshift(c, 16)
            local col = bit.band(bit.rshift(c, 6), 1023)
            local winnr = bit.band(c, 63)
            return line, col, winnr
          end,
        },
        init = function(self)
          local data = require("nvim-navic").get_data() or {}
          local children = {}
          -- create a child for each level
          for i, d in ipairs(data) do
            -- encode line and column numbers into a single integer
            local pos = self.enc(d.scope.start.line, d.scope.start.character, self.winnr)
            local child = {
              {
                provider = d.icon,
                hl = self.type_hl[d.type],
              },
              {
                -- escape `%`s (elixir) and buggy default separators
                provider = d.name:gsub("%%", "%%%%"):gsub("%s*->%s*", ""),
                -- highlight icon only or location name as well
                -- hl = self.type_hl[d.type],

                on_click = {
                  -- pass the encoded position through minwid
                  minwid = pos,
                  callback = function(_, minwid)
                    -- decode
                    local line, col, winnr = self.dec(minwid)
                    vim.api.nvim_win_set_cursor(vim.fn.win_getid(winnr), { line, col })
                  end,
                  name = "heirline_navic",
                },
              },
            }
            -- add a separator only if needed
            if #data > 1 and i < #data then
              table.insert(child, {
                provider = " > ",
                hl = { fg = "grey" },
              })
            end
            table.insert(children, child)
          end
          -- instantiate the new child, overwriting the previous one
          self.child = self:new(children, 1)
        end,
        -- evaluate the children containing navic components
        provider = function(self) return self.child:eval() end,
        hl = { fg = "gray" },
        update = "CursorMoved",
      }
    end,
  },

  -- neo-tree: file explorer
  -- https://github.com/nvim-neo-tree/neo-tree.nvim
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = function(_, opts) opts.window.position = "right" end,
  },

  -- nvim-treesitter: Syntax highlighting
  -- https://github.com/nvim-treesitter/nvim-treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- list like portions of a table cannot be merged naturally and require the user to merge it manually
      -- check to make sure the key exists
      if not opts.ensure_installed then opts.ensure_installed = {} end
      vim.list_extend(opts.ensure_installed, {
        "lua",
        "vim",
        "astro",
        "css",
        "devicetree",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "tsx",
        "typescript",
        "vim",
        "yaml",
      })
    end,
  },

  -- Fuzzy Finder (files, lsp, etc)
  -- https://github.com/nvim-telescope/telescope.nvim
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "mollerhoj/telescope-recent-files.nvim" },
    },
    keys = {
      {
        "<leader>ff",
        function() require("telescope").extensions["recent-files"].recent_files {} end,
        desc = "Find files",
      },
    },
  },
}
