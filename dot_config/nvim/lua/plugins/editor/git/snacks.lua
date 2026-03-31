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
    local utils = require("utils")
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
        gh_diff = {
          layout = { preset = "fullscreen", fullscreen = true },
          on_change = gh_remap_preview_keys,
          formatters = { file = { filename_only = true } },
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
