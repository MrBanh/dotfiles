return {
  "mfussenegger/nvim-dap",
  keys = {
    {
      "<F5>",
      function()
        require("dap").continue()
      end,
      desc = "Run/Continue",
    },
    {
      "<F10>",
      function()
        require("dap").step_over()
      end,
      desc = "Step Over",
    },
    {
      "<F11>",
      function()
        require("dap").step_into()
      end,
      desc = "Step Into",
    },
    {
      "<F12>",
      function()
        require("dap").step_out()
      end,
      desc = "Step Out",
    },
  },

  opts = function()
    local dap = require("dap")
    local js_filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" }

    -- Add your custom configurations to existing ones
    for _, language in ipairs(js_filetypes) do
      -- Ensure configurations exist (they should from LazyVim)
      dap.configurations[language] = dap.configurations[language] or {}

      -- Add your custom configurations
      local custom_configs = {
        {
          type = "pwa-node",
          request = "attach",
          name = "Auto Attach (9229)",
          port = 9229,
          restart = true,
          sourceMaps = true,
          protocol = "inspector",
          skipFiles = { "<node_internals>/**" },
          cwd = "${workspaceFolder}",
          localRoot = "${workspaceFolder}",
          continueOnAttach = true,
        },
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch with args",
          program = "${file}",
          args = function()
            local args_string = vim.fn.input("Arguments: ")
            return vim.split(args_string, " ")
          end,
          cwd = "${workspaceFolder}",
          console = "integratedTerminal",
          skipFiles = { "<node_internals>/**" },
        },
        {
          type = "pwa-node",
          request = "launch",
          name = "Debug via npm",
          runtimeExecutable = "npm",
          runtimeArgs = function()
            local script = vim.fn.input("npm script: ")
            return { "run", script }
          end,
          cwd = "${workspaceFolder}",
          console = "integratedTerminal",
          skipFiles = { "<node_internals>/**" },
        },
        {
          type = "pwa-node",
          request = "launch",
          name = "Debug Selenium Test",
          program = "${file}",
          cwd = "${workspaceFolder}",
          console = "integratedTerminal",
          skipFiles = { "<node_internals>/**" },
          env = {
            NODE_ENV = "test",
            SELENIUM_BROWSER = "chrome",
            HEADLESS = "false",
          },
          timeout = 30000,
        },
      }

      -- Append custom configs to existing ones
      for _, config in ipairs(custom_configs) do
        table.insert(dap.configurations[language], config)
      end
    end
  end,
}
