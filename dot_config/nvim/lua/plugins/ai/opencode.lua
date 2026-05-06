local keymap_prefix = "<leader>a"
local toggle = "<M-/>"

local opencode_cmd = "dvx opencode --port --continue"
---@type snacks.terminal.Opts
local snacks_terminal_opts = {
  env = {
    -- Neutralize tmux detection so opencode emits plain OSC 52 clipboard
    -- writes instead of wrapping them in tmux DCS passthrough
    -- (\ePtmux;...\e\\). Nvim's libvterm doesn't fully parse the
    -- doubled-escape DCS wrapper, which causes the base64 payload to leak
    -- onto the screen as visible text. With TMUX unset, opencode emits a
    -- plain \e]52;c;<b64> sequence that libvterm forwards to the outer
    -- tmux pane, which then hands it to the system clipboard via
    -- set-clipboard + allow-passthrough.
    TMUX = "",
    TMUX_PANE = "",
  },
  win = {
    position = "right",
    width = 0.5,
    enter = false,
    on_win = function(win)
      -- Set up keymaps and cleanup for an arbitrary terminal
      require("opencode.terminal").setup(win.win)

      ---@param mode string|string[]
      ---@param lhs string
      ---@param rhs string|function
      ---@param desc? string
      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = win.buf, desc = desc })
      end

      map({ "n", "t" }, "<C-u>", function()
        require("opencode").command("session.half.page.up")
      end, "Scroll opencode up")

      map({ "n", "t" }, "<C-d>", function()
        require("opencode").command("session.half.page.down")
      end, "Scroll opencode down")

      map({ "t" }, "<M-C-g>", function()
        require("opencode").command("session.last")
      end, "Go to last opencode message")

      map({ "n", "t" }, "<C-b>", function()
        Snacks.picker.buffers({
          confirm = "opencode_send",
        })
      end, "Add buffer to opencode")

      map({ "n", "t" }, "<C-f>", function()
        Snacks.explorer({
          win = {
            list = { keys = {
              ["<CR>"] = "opencode_send",
            } },
          },
        })
      end, "Add file(s) to opencode")
    end,
  },
}

return {
  "nickjvandyke/opencode.nvim",
  version = "*", -- Latest stable release
  dependencies = {
    {
      -- `snacks.nvim` integration is recommended, but optional
      ---@module "snacks" <- Loads `snacks.nvim` types for configuration intellisense
      "folke/snacks.nvim",
      optional = true,
      opts = {
        input = {}, -- Enhances `ask()`
        picker = { -- Enhances `select()`
          actions = {
            opencode_send = function(picker)
              local selected = picker:selected({ fallback = true })
              local items = {}
              local names = {}
              for _, item in ipairs(selected) do
                if item.file then
                  table.insert(
                    items,
                    require("opencode.context").format(item.file, {
                      start_line = item.pos and item.pos[1] or nil,
                      start_col = item.pos and item.pos[2] or nil,
                      end_line = item.end_pos and item.end_pos[1] or nil,
                      end_col = item.end_pos and item.end_pos[2] or nil,
                    })
                  )
                  table.insert(names, vim.fn.fnamemodify(item.file, ":t"))
                else
                  table.insert(items, item.text)
                  table.insert(names, item.text)
                end
              end

              if #items > 0 then
                require("opencode").prompt(table.concat(items, "\n") .. "\n")
                vim.notify(
                  ("Sent %d item%s to opencode:\n%s"):format(
                    #items,
                    #items == 1 and "" or "s",
                    table.concat(names, "\n")
                  ),
                  vim.log.levels.INFO,
                  { title = "opencode" }
                )
              end
            end,
          },
          win = {
            input = {
              keys = {
                ["<M-CR>"] = { "opencode_send", mode = { "n", "i" } },
              },
            },
            list = {
              keys = {
                ["<M-CR>"] = { "opencode_send", mode = { "n", "i" } },
              },
            },
          },
        },
      },
    },
  },
  init = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      server = {
        start = function()
          require("snacks.terminal").open(opencode_cmd, snacks_terminal_opts)
        end,
        stop = function()
          require("snacks.terminal").get(opencode_cmd, snacks_terminal_opts):close()
        end,
        toggle = function()
          require("snacks.terminal").toggle(opencode_cmd, snacks_terminal_opts)
        end,
      },
      lsp = {
        enabled = true,
      },
    }

    vim.o.autoread = true -- Required for `opts.events.reload`
  end,
  keys = {
    {
      toggle,
      function()
        require("opencode").toggle()
      end,
      mode = { "n", "t" },
      desc = "Toggle opencode",
    },
    {
      keymap_prefix .. ":",
      function()
        require("opencode").select()
      end,
      mode = { "n", "x" },
      desc = "Opencode actions…",
    },
    {
      keymap_prefix .. "a",
      function()
        require("opencode").ask("@this: ", { submit = true })
      end,
      mode = { "n", "x" },
      desc = "Ask opencode…",
    },
    {
      keymap_prefix .. "f",
      function()
        require("snacks.terminal").focus(opencode_cmd, snacks_terminal_opts)
      end,
      mode = { "n", "t", "i", "x" },
      desc = "Focus opencode",
    },
    {
      keymap_prefix .. "g",
      function()
        require("opencode").prompt("@buffer\n")
      end,
      desc = "Send File to opencode",
    },
    {
      keymap_prefix .. "t",
      function()
        require("opencode").prompt("@this\n")
      end,
      mode = { "x", "n" },
      desc = "Send This",
    },
    {
      keymap_prefix .. "v",
      function()
        local lines = require("utils").get_visual_selection_text()
        if not lines or #lines == 0 then
          return
        end
        local text = table.concat(lines, "\n") .. "\n"

        -- We skip the public `prompt()`
        -- API because it runs the input through `Context:render()`, which
        -- expands any `@buffer`, `@this`, etc. tokens that happen to appear
        -- inside the user's selection (e.g. when sending source code that
        -- already references those placeholders). Talk to the server
        -- directly so the text is treated literally.
        require("opencode.server").get():next(function(server)
          server:tui_append_prompt(text)
        end)
      end,
      mode = { "x" },
      desc = "Send Visual Selection",
    },
    {
      "go",
      function()
        return require("opencode").operator("@this\n")
      end,
      mode = { "n", "x" },
      expr = true,
      desc = "Add range to opencode",
    },
    {
      "goo",
      function()
        return require("opencode").operator("@this\n") .. "_"
      end,
      expr = true,
      desc = "Add line to opencode",
    },
  },
}
