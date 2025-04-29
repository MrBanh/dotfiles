local js_ts_print_var_statements = {
  'console.log("[LOGS] %s → %%s", %s);',
}

return {
  "ThePrimeagen/refactoring.nvim",
  opts = {
    print_var_statements = {
      javascript = js_ts_print_var_statements,
      javascriptreact = js_ts_print_var_statements,
      typescript = js_ts_print_var_statements,
      typescriptreact = js_ts_print_var_statements,
    },
  },
}
