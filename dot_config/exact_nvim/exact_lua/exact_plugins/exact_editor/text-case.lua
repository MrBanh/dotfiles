local enabled_methods = {
  "to_upper_case",
  "to_lower_case",
  "to_snake_case",
  "to_dash_case",
  "to_title_dash_case",
  "to_constant_case",
  "to_dot_case",
  "to_comma_case",
  "to_phrase_case",
  "to_camel_case",
  "to_pascal_case",
  "to_title_case",
  "to_path_case",
  "to_upper_phrase_case",
  "to_lower_phrase_case",
}

return {
  "johmsalas/text-case.nvim",
  lazy = true,
  cmd = {
    "Subs",
    "TextCaseStartReplacingCommand",

    -- custom commands
    "TextCase",
    "TextCaseLSP",
  },
  opts = {
    default_keymappings_enabled = false,
    enabled_methods = enabled_methods,
  },
  config = function(_, opts)
    local textcase = require("textcase")
    textcase.setup(opts)

    -- Helper function to validate method
    local function is_valid_method(method)
      for _, enabled_method in ipairs(enabled_methods) do
        if enabled_method == method then
          return true
        end
      end
      return false
    end

    -- Helper function for completion (without "to_" prefix)
    local function complete_methods()
      local completions = {}
      for _, method in ipairs(enabled_methods) do
        table.insert(completions, (method:gsub("^to_", "")))
      end
      return completions
    end

    -- Helper function to ensure method has "to_" prefix
    local function normalize_method(method)
      if not method:match("^to_") then
        return "to_" .. method
      end
      return method
    end

    -- TextCase: uses current_word in normal mode, operator in visual mode
    vim.api.nvim_create_user_command("TextCase", function(cmd_opts)
      local method = normalize_method(cmd_opts.args)

      if is_valid_method(method) then
        if cmd_opts.range > 0 then
          -- Visual mode: use operator with visual selection
          vim.cmd("normal! gv")
          textcase.operator(method)
        else
          -- Normal mode: use current_word
          textcase.current_word(method)
        end
      else
        vim.notify("Invalid text case method: " .. cmd_opts.args, vim.log.levels.ERROR)
      end
    end, {
      nargs = 1,
      range = true,
      complete = complete_methods,
      desc = "Convert current word or selection to specified case",
    })

    -- TextCaseLSP: uses lsp_rename
    vim.api.nvim_create_user_command("TextCaseLSP", function(cmd_opts)
      local method = normalize_method(cmd_opts.args)

      if is_valid_method(method) then
        textcase.lsp_rename(method)
      else
        vim.notify("Invalid text case method: " .. cmd_opts.args, vim.log.levels.ERROR)
      end
    end, {
      nargs = 1,
      complete = complete_methods,
      desc = "Convert text case using LSP rename",
    })
  end,
}
