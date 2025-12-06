return {
  "folke/snacks.nvim",
  opts = {
    bigfile = {},
    lazygit = {
      config = {
        -- TODO: uncomment once LazyVim fixes
        os = {
          edit = '[ -z "$NVIM" ] && (nvim -- {{filename}}) || (nvim --server "$NVIM" --remote-send "q" && nvim --server "$NVIM" --remote {{filename}})',
          editAtLine = '[ -z "$NVIM" ] && (nvim +{{line}} -- {{filename}}) || (nvim --server "$NVIM" --remote-send "q" &&  nvim --server "$NVIM" --remote {{filename}} && nvim --server "$NVIM" --remote-send ":{{line}}<CR>")',
          editAtLineAndWait = "nvim +{{line}} {{filename}}",
          openDirInEditor = '[ -z "$NVIM" ] && (nvim -- {{dir}}) || (nvim --server "$NVIM" --remote-send "q" && nvim --server "$NVIM" --remote {{dir}})',
        },
      },
    },
    image = {
      enabled = false,
      formats = {},
    },
    notifier = {
      top_down = false,
    },
    -- https://github.com/folke/snacks.nvim/blob/main/docs/picker.md#%EF%B8%8F-config
    picker = {
      formatters = {
        file = {
          filename_first = true, -- display filename before the file path
          ---@type "left"|"center"|"right"
          truncate = "center",
          min_width = 80, -- minimum length of the truncated path
        },
      },
      hidden = true,
      actions = {
        -- yank and paste file + rename if duplicate
        -- https://github.com/folke/snacks.nvim/discussions/1748
        explorer_paste_rename = function(picker)
          local uv = vim.uv or vim.loop
          local Tree = require("snacks.explorer.tree")
          local M = require("snacks.explorer.actions")

          local files = vim.split(vim.fn.getreg(vim.v.register or "+") or "", "\n", { plain = true })
          files = vim.tbl_filter(function(file)
            return file ~= "" and vim.fn.filereadable(file) == 1
          end, files)

          if #files == 0 then
            return Snacks.notify.warn(("The `%s` register does not contain any files"):format(vim.v.register or "+"))
          end
          if #files == 1 then
            local file = files[1]
            local base = vim.fn.fnamemodify(file, ":t")
            local dir = picker:dir()
            Snacks.input({
              prompt = "Rename pasted file",
              default = base,
            }, function(value)
              if not value or value:find("^%s*$") then
                return
              end
              local target = vim.fs.normalize(dir .. "/" .. value)
              if uv.fs_stat(target) then
                Snacks.notify.warn("File already exists:\n- `" .. target .. "`")
                return
              end
              Snacks.picker.util.copy_path(file, target)
              Tree:refresh(dir)
              Tree:open(dir)
              M.update(picker, { target = dir })
            end)
          else
            local dir = picker:dir()
            Snacks.picker.util.copy(files, dir)
            Tree:refresh(dir)
            Tree:open(dir)
            M.update(picker, { target = dir })
          end
        end,
        find_in_project = function(picker, item, action)
          picker:close()
          local dir = item.file
          Snacks.picker.files({
            dirs = {
              dir,
            },
          })
        end,
      },
      layouts = {
        custom_ivy = {
          cycle = false,
          layout = {
            box = "vertical",
            backdrop = false,
            row = -1,
            width = 0,
            height = 0.4,
            border = "top",
            title = " {title} {live} {flags}",
            title_pos = "left",
            { win = "input", height = 1, border = "none" },
            {
              box = "horizontal",
              { win = "list", border = true },
              { win = "preview", title = "{preview}", width = 0.5, border = true, title_pos = "left" },
            },
          },
        },
      },
      layout = "custom_ivy",
      matcher = {
        fuzzy = true, -- use fuzzy matching
        smartcase = true, -- use smartcase
        ignorecase = true, -- use ignorecase
        sort_empty = false, -- sort results when the search string is empty
        filename_bonus = true, -- give bonus for matching file names (last part of the path)
        file_pos = true, -- support patterns like `file:line:col` and `file:line`
        -- the bonusses below, possibly require string concatenation and path normalization,
        -- so this can have a performance impact for large lists and increase memory usage
        cwd_bonus = true, -- give bonus for matching files in the cwd
        frecency = true, -- frecency bonus
        history_bonus = true, -- give more weight to chronological order
      },
      win = {
        -- input window: when focus is on input box above list
        input = {
          keys = {
            ["<Esc>"] = { "close", mode = { "n", "i" } }, -- close picker instead of going to normal mode
            ["<LocalLeader>C"] = { "toggle_cwd", mode = { "n", "i" } },
            ["<a-p>"] = { "focus_preview", mode = { "i", "n" } },
          },
        },
        -- result list window: when focus in on list
        list = {
          keys = {
            ["<LocalLeader>C"] = { "toggle_cwd", mode = { "n", "i" } },
            ["<a-p>"] = { "focus_preview", mode = { "i", "n" } },
          },
          wo = {
            number = true,
            relativenumber = true,
          },
        },
        -- preview window
        preview = {
          keys = {
            ["<a-p>"] = "focus_list",
          },
        },
      },
      sources = {
        files = {
          hidden = true,
        },
        explorer = {
          auto_close = true,
          layout = { preset = "default", preview = true },
          win = {
            input = {
              keys = {
                ["<LocalLeader>c"] = "tcd",
                ["<LocalLeader>C"] = { "toggle_cwd", mode = { "n", "i" } },
              },
            },
            list = {
              keys = {
                ["p"] = "explorer_paste_rename",
                ["<c-/>"] = "terminal",
                ["<LocalLeader>c"] = "tcd",
                ["<LocalLeader>C"] = { "toggle_cwd", mode = { "n", "i" } },
              },
              wo = {
                number = true,
                relativenumber = true,
              },
            },
          },
        },
        gh_diff = {
          layout = { preset = "default", fullscreen = true },
        },
        gh_issue = {
          layout = { preset = "default", fullscreen = true },
        },
        gh_pr = {
          layout = { preset = "default", fullscreen = true },
        },
        git_diff = {
          layout = { preset = "default", fullscreen = true },
        },
        projects = {
          dev = { "~/dev", "~/projects", "~/src", "~/.config" },
        },
      },
    },
    scroll = {
      enabled = false,
    },
    terminal = {
      win = {
        style = vim.g.floating_terminal and {
          border = "rounded",
          position = "float",
          backdrop = 60,
          height = 0.6,
          width = 0.6,
          zindex = 50,
        } or "terminal",
      },
    },
  },
  keys = {
    {
      "<leader>sP",
      function()
        Snacks.picker.lazy()
      end,
      desc = "Search for Plugin Spec",
    },
    {
      "<leader>gF",
      function()
        Snacks.lazygit.log_file()
      end,
      desc = "LazyGit File Log",
    },
    {
      "<leader>fp",
      function()
        Snacks.picker.projects({
          confirm = "find_in_project",
        })
      end,
      desc = "Find in Projects",
    },
    {
      "<leader>fP",
      function()
        Snacks.picker.zoxide({
          confirm = "find_in_project",
        })
      end,
      desc = "Find in Projects (Zoxide)",
    },
    {
      "<leader>qp",
      function()
        Snacks.picker.projects({})
      end,
      desc = "Load Projects Session",
    },
    {
      "<leader>qP",
      function()
        Snacks.picker.zoxide({})
      end,
      desc = "Load Projects Session (Zoxide)",
    },
  },

  config = function(_, opts)
    require("snacks").setup(opts)

    -- Register custom GitHub actions
    require("utils.snacks.gh").register()
  end,
}
