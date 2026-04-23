---@param opts refactor.print_var.code_generation.Opts
local js_ts_print_var = function(opts)
  return ([[console.log("[LOGS] %s %s %s → ", %s)]]):format(
    opts.debug_path:gsub('"', '\\"'),
    opts.identifier_str:gsub('"', '\\"'),
    opts.count,
    opts.identifier
  )
end

local print_var_code_generation = {
  print_var = {
    javascript = js_ts_print_var,
    typescript = js_ts_print_var,
    tsx = js_ts_print_var,
  },
}

---@param opts refactor.print_loc.code_generation.Opts
local js_ts_print_loc = function(opts)
  return ([[console.log("[LOGS] %s %s -------------")]]):format(opts.debug_path, opts.count)
end

local print_loc_code_generation = {
  print_loc = {
    javascript = js_ts_print_loc,
    typescript = js_ts_print_loc,
    tsx = js_ts_print_loc,
  },
}

return {
  "ThePrimeagen/refactoring.nvim",
  dependencies = {
    "lewis6991/async.nvim",
  },
  keys = {
    -- LazyVim's default binding feeds `g@ag`, where `ag` is mini.ai's custom
    -- "around buffer" textobject. It can fail when mini.ai hasn't finished
    -- registering. Here we bypass the operator-pending dance: call cleanup()
    -- to set operatorfunc + internal state, set the `[` / `]` marks to the
    -- whole buffer, then invoke the operatorfunc directly.
    {
      "<leader>rc",
      function()
        require("refactoring.debug").cleanup({ restore_view = true })
        local buf = vim.api.nvim_get_current_buf()
        local last_line = vim.api.nvim_buf_line_count(buf)
        local last_line_text = vim.api.nvim_buf_get_lines(buf, last_line - 1, last_line, true)[1] or ""
        local last_col = math.max(0, #last_line_text - 1)
        vim.api.nvim_buf_set_mark(buf, "[", 1, 0, {})
        vim.api.nvim_buf_set_mark(buf, "]", last_line, last_col, {})
        require("refactoring.debug").debug_operatorfunc("line")
      end,
      desc = "Debug Cleanup (whole buffer)",
    },
  },
  opts = {
    -- https://github.com/ThePrimeagen/refactoring.nvim/blob/master/lua/refactoring/config.lua
    debug = {
      print_var = {
        code_generation = print_var_code_generation,
      },
      print_loc = {
        code_generation = print_loc_code_generation,
      },
    },
  },
}
