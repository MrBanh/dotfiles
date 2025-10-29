local add_watch_expression = function()
  local dapui = require("dapui")
  local opt_cloned = vim.opt.iskeyword
  vim.opt.iskeyword:append(".")
  local variable = vim.fn.expand("<cword>")
  vim.opt.iskeyword = opt_cloned
  local watch_expression_list = dapui.elements.watches.get()
  for _, value in ipairs(watch_expression_list) do
    if value.expression == variable then
      require("utils.notify").notify("Expression [" .. variable .. "] Already Existed", "warn", "DapUi")
      do
        return
      end
    end
  end
  dapui.elements.watches.add(variable)
end

local remove_watch_expression = function()
  local dapui = require("dapui")
  local watch_expression_list = dapui.elements.watches.get()
  local expression_map_id = {}
  local expression_names = {}
  for index, value in ipairs(watch_expression_list) do
    expression_map_id[value.expression] = index
    table.insert(expression_names, value.expression)
  end
  vim.ui.select(expression_names, { prompt = "Select Watch Expression Del" }, function(expression)
    if expression == nil then
      return
    end
    local id = expression_map_id[expression]
    dapui.elements.watches.remove(id)
  end)
end

local clean_all_watch_expression = function()
  local dapui = require("dapui")
  local watch_expression_list = dapui.elements.watches.get()
  for index, _ in ipairs(watch_expression_list) do
    dapui.elements.watches.remove(index)
  end
end

return {
  {
    "mfussenegger/nvim-dap",
    keys = {
      {
        "<leader>dw",
        false,
      },
      {
        "<leader>dR",
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
    "rcarriga/nvim-dap-ui",
    keys = {
      {
        "<leader>dw",
        "",
        desc = "Watch Epression",
      },
      {
        "<leader>dwa",
        add_watch_expression,
        desc = "Add Watch Expression",
      },
      {
        "<leader>dwd",
        remove_watch_expression,
        desc = "Delete Watch Expression",
      },
      {
        "<leader>dwD",
        clean_all_watch_expression,
        desc = "Delete All Watch Expression",
      },
      {
        "<leader>dW",
        function()
          require("dap.ui.widgets").hover()
        end,
        desc = "Widgets",
      },
      {
        "<leader>dU",
        function()
          require("dapui").toggle({
            reset = true,
          })
        end,
        desc = "Dap UI (reset)",
      },
      {
        "<M-S-k>",
        function()
          require("dapui").eval()
        end,
        desc = "Eval",
      },
    },
  },
}
