-- Workaround: snacks picker's set_buf() doesn't re-apply buffer-local keymaps
-- when swapping to a non-scratch buffer (e.g. gh:// with filetype markdown.gh).
-- Calling win:map() ensures preview keymaps stay bound after the buffer swap.
local function gh_remap_preview_keys(picker)
  vim.schedule(function()
    if picker.preview and picker.preview.win:valid() then
      picker.preview.win:map()
    end
  end)
end

local function open_commit(_, item)
  if item and item.commit then
    local utils = require("user.utils")
    utils.open_commit_in_browser(item.commit)
  end
end

return {
  "folke/snacks.nvim",
  opts = {
    ---@class snacks.lazygit.Config: snacks.terminal.Opts
    lazygit = {
      config = {
        os = {
          edit = '[ -z "$NVIM" ] && (nvim -- {{filename}}) || (nvim --server "$NVIM" --remote-send "q" && nvim --server "$NVIM" --remote {{filename}})',
          editAtLine = '[ -z "$NVIM" ] && (nvim +{{line}} -- {{filename}}) || (nvim --server "$NVIM" --remote-send "q" &&  nvim --server "$NVIM" --remote {{filename}} && nvim --server "$NVIM" --remote-send ":{{line}}<CR>")',
          editAtLineAndWait = "nvim +{{line}} {{filename}}",
          openDirInEditor = '[ -z "$NVIM" ] && (nvim -- {{dir}}) || (nvim --server "$NVIM" --remote-send "q" && nvim --server "$NVIM" --remote {{dir}})',
        },
      },
      win = {
        style = {
          width = 0,
          height = 0,
        },
      },
    },
    picker = {
      layouts = {
        fullscreen = {
          layout = {
            box = "horizontal",
            width = 0,
            min_width = 120,
            height = 0,
            {
              box = "vertical",
              border = true,
              title = "{title}",
              { win = "input", height = 1, border = "bottom" },
              { win = "list", border = "none" },
            },
            { win = "preview", title = "{preview}", border = true, width = 0.75 },
          },
        },
      },
      sources = {
        gh_actions = {
          focus = "list",
          on_show = function()
            vim.cmd.stopinsert()
          end,
        },
        gh_diff = {
          layout = { preset = "fullscreen", fullscreen = true },
          on_change = gh_remap_preview_keys,
          formatters = { file = { filename_only = true } },
          focus = "list",
        },
        gh_issue = {
          layout = { preset = "default", fullscreen = true },
          on_change = gh_remap_preview_keys,
        },
        gh_pr = {
          layout = { preset = "default", fullscreen = true },
          on_change = gh_remap_preview_keys,
        },
        git_diff = {
          layout = { preset = "default", fullscreen = true },
          focus = "list",
        },
        git_log = {
          actions = {
            open_commit = open_commit,
          },
          win = {
            input = {
              keys = {
                ["<c-g>"] = { "open_commit", mode = { "n", "i" } },
              },
            },
            list = {
              keys = {
                ["<c-g>"] = { "open_commit" },
              },
            },
          },
        },
        git_log_file = {
          actions = {
            open_commit = open_commit,
          },
          win = {
            input = {
              keys = {
                ["<c-g>"] = { "open_commit", mode = { "n", "i" } },
              },
            },
            list = {
              keys = {
                ["<c-g>"] = { "open_commit" },
              },
            },
          },
        },
        git_log_line = {
          actions = {
            open_commit = open_commit,
          },
          win = {
            input = {
              keys = {
                ["<c-g>"] = { "open_commit", mode = { "n", "i" } },
              },
            },
            list = {
              keys = {
                ["<c-g>"] = { "open_commit" },
              },
            },
          },
        },
      },
    },
  },
  keys = {
    {
      "<leader>gF",
      function()
        Snacks.lazygit.log_file()
      end,
      desc = "LazyGit File Log",
    },
    {
      "<leader>gw",
      function()
        Snacks.picker.pick({
          source = "wt",
          title = "Worktrees",
          finder = function()
            local cwd = vim.fn.getcwd()
            local out = vim.fn.systemlist({ "wt", "-C", cwd, "list", "--format", "json" })
            if vim.v.shell_error ~= 0 then
              vim.notify("wt list failed: " .. table.concat(out, "\n"), vim.log.levels.ERROR)
              return {}
            end
            local ok, data = pcall(vim.json.decode, table.concat(out, "\n"))
            if not ok or type(data) ~= "table" then
              return {}
            end
            local items = {}
            for _, wt in ipairs(data) do
              local branch = wt.branch or "(detached)"
              local marker = wt.is_current and "● " or "  "
              items[#items + 1] = {
                text = marker .. branch,
                branch = branch,
                file = wt.path,
                cwd = wt.path,
                data = wt,
              }
            end
            return items
          end,
          format = function(item)
            local wt = item.data
            local ret = {}
            ret[#ret + 1] = { item.text, wt.is_current and "SnacksPickerDirectory" or "" }
            ret[#ret + 1] = { "  " }
            ret[#ret + 1] = { wt.commit and wt.commit.short_sha or "", "SnacksPickerGitCommit" }
            ret[#ret + 1] = { "  " }
            local ahead = wt.main and wt.main.ahead or 0
            local behind = wt.main and wt.main.behind or 0
            if ahead > 0 then
              ret[#ret + 1] = { "↑" .. ahead, "diffAdded" }
              ret[#ret + 1] = { " " }
            end
            if behind > 0 then
              ret[#ret + 1] = { "↓" .. behind, "diffRemoved" }
            end
            return ret
          end,
          preview = function(ctx)
            local item = ctx.item
            if not item or not item.cwd then
              return false
            end
            local lines = vim.fn.systemlist({
              "git",
              "-C",
              item.cwd,
              "log",
              "--oneline",
              "--decorate",
              "--color=never",
              "-n",
              "20",
            })
            if vim.v.shell_error ~= 0 then
              lines = { "git log failed:", unpack(lines) }
            end
            ctx.preview:reset()
            ctx.preview:set_lines(lines)
            ctx.preview:highlight({ ft = "git" })
            return true
          end,
          confirm = function(picker, item)
            picker:close()
            if not (item and item.cwd) then
              return
            end
            local path = vim.fn.fnamemodify(item.cwd, ":p"):gsub("/$", "")
            local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":p"):gsub("/$", "")
            if path == cwd then
              vim.notify("Already in worktree: " .. path)
              return
            end
            if vim.env.TMUX then
              -- Replace the current pane's process: kill this nvim, start a
              -- fresh interactive shell in the new worktree that auto-runs
              -- `nvim .`. When that nvim exits, the shell remains in `path`.
              local shell = vim.env.SHELL or "/bin/zsh"
              local nvim_cmd = "nvim -c " .. vim.fn.shellescape("silent! lua require('persistence').load()")
              local cmd = string.format(
                "%s -i -c %s",
                vim.fn.shellescape(shell),
                vim.fn.shellescape(string.format("%s; exec %s -i", nvim_cmd, shell))
              )
              vim.fn.jobstart({
                "tmux",
                "respawn-pane",
                "-k",
                "-c",
                path,
                cmd,
              }, { detach = true })
            else
              vim.cmd.tcd(path)
              vim.notify("tcd → " .. path .. " (not in tmux; nvim not relaunched)")
            end
          end,
        })
      end,
      desc = "Worktrees (wt)",
    },
    {
      "<leader>go",
      "",
      desc = "Open in browser",
      mode = { "n", "v" },
    },
    {
      "<leader>gob",
      function()
        Snacks.gitbrowse({
          what = "branch",
        })
      end,
      desc = "Git Open Branch",
      mode = { "n", "v" },
    },
    {
      "<leader>gof",
      function()
        Snacks.gitbrowse({
          what = "file",
        })
      end,
      desc = "Git Open File",
      mode = { "n", "v" },
    },
    {
      "<leader>gop",
      function()
        Snacks.gitbrowse({
          what = "permalink",
        })
      end,
      desc = "Git Open Permalink",
      mode = { "n", "v" },
    },
    {
      "<leader>goc",
      function()
        Snacks.gitbrowse({
          what = "commit",
        })
      end,
      desc = "Git Open Commit on cursor",
      mode = { "n", "v" },
    },
  },
}
