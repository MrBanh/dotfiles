return {
  "mfussenegger/nvim-dap",
  depedencies = {
    {
      "mason-org/mason.nvim",
      opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        table.insert(opts.ensure_installed, "chrome-debug-adapter")
      end,
    },
  },
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

    -- adapter definitions
    if not dap.adapters["chrome"] then
      dap.adapters["chrome"] = {
        type = "executable",
        command = "node",
        args = {
          LazyVim.get_pkg_path("chrome-debug-adapter", "out/src/chromeDebug.js"),
        },
      }
    end

    local js_filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" }
    for _, language in ipairs(js_filetypes) do
      dap.configurations[language] = dap.configurations[language] or {}

      -- Add your custom configurations
      local custom_configs = {}

      -- Append custom configs to existing ones
      for _, config in ipairs(custom_configs) do
        table.insert(dap.configurations[language], config)
      end
    end
  end,
}
