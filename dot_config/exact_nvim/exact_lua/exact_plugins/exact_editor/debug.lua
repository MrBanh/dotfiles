local prefix = "<leader>d"

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "igorlfs/nvim-dap-view",
    },
    keys = {
      {
        prefix .. "w",
        "<cmd>DapViewWatch<cr>",
        mode = { "n", "x" },
        desc = "Watch Expression",
      },
      {
        prefix .. "R",
        function()
          require("dap").restart()
        end,
        desc = "Restart Debugging",
      },
      {
        "<F2>",
        function()
          require("dap").step_over()
        end,
        desc = "Step Over",
      },
      {
        "<F3>",
        function()
          require("dap").step_into()
        end,
        desc = "Step Into",
      },
      {
        "<F4>",
        function()
          require("dap").step_out()
        end,
        desc = "Step Out",
      },
      {
        "<F5>",
        function()
          require("dap").continue()
        end,
        desc = "Run/Continue",
      },
    },
    opts = function()
      local dap = require("dap")

      local js_filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" }
      for _, language in ipairs(js_filetypes) do
        local runtimeExecutable = nil
        local args = {}
        if language:find("typescript") then
          if vim.fn.executable("tsx") == 1 then
            runtimeExecutable = "tsx"
            args = { "${file}" }
          elseif vim.fn.executable("ts-node") == 1 then
            runtimeExecutable = "ts-node"
            args = { "--esm", "${file}" }
          else
            runtimeExecutable = "node"
            args = { "--inspect", "${file}" }
          end
        end

        local skipFiles = { "<node_internals>/**", "node_modules/**" }
        local resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" }

        local configs = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            cwd = "${workspaceFolder}",
            sourceMaps = true,
            runtimeExecutable = runtimeExecutable,
            args = args,
            skipFiles = skipFiles,
            resolveSourceMapLocations = resolveSourceMapLocations,
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
            sourceMaps = true,
            runtimeExecutable = runtimeExecutable,
            skipFiles = skipFiles,
            resolveSourceMapLocations = resolveSourceMapLocations,
          },
        }

        dap.configurations[language] = configs
      end
    end,
  },
  {
    --https://igorlfs.github.io/nvim-dap-view/configuration
    "igorlfs/nvim-dap-view",
    main = "dap-view",
    opts = {
      auto_toggle = true,
      icons = {
        collapsed = " ",
      },
      virtual_text = {
        enabled = true,
      },
      winbar = {
        sections = {
          "scopes",
          "watches",
          "breakpoints",
          "exceptions",
          "threads",
          "repl",
          "console",
        },
        default_section = "scopes",
        separators = nil,
        controls = {
          enabled = true,
        },
      },
      windows = {
        size = 0.4,
        position = "below",
        terminal = {
          size = 0.5,
          position = "right",
        },
      },
    },
    keys = {
      {
        prefix .. "u",
        "<cmd>DapViewToggle<cr>",
        desc = "Dap View (Toggle)",
      },
      {
        prefix .. "e",
        "<cmd>DapViewHover<cr>",
        mode = { "n", "x" },
        desc = "Eval (Hover)",
      },
      {
        prefix .. "w",
        "<cmd>DapViewWatch<cr>",
        mode = { "n", "x" },
        desc = "Watch Expression",
      },
    },
  },
}
