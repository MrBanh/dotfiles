local SymbolKind = vim.lsp.protocol.SymbolKind

return {
  "Wansmer/symbol-usage.nvim",
  event = "LspAttach", -- need run before LspAttach if you use nvim 0.9. On 0.10 use 'LspAttach'
  config = function()
    local function h(name)
      return vim.api.nvim_get_hl(0, { name = name })
    end

    -- hl-groups can have any name
    vim.api.nvim_set_hl(0, "SymbolUsageRounding", { fg = h("CursorLine").bg, italic = true })
    vim.api.nvim_set_hl(0, "SymbolUsageContent", { bg = h("CursorLine").bg, fg = h("Comment").fg, italic = true })
    vim.api.nvim_set_hl(0, "SymbolUsageRef", { fg = h("Function").fg, bg = h("CursorLine").bg, italic = true })
    vim.api.nvim_set_hl(0, "SymbolUsageDef", { fg = h("Type").fg, bg = h("CursorLine").bg, italic = true })
    vim.api.nvim_set_hl(0, "SymbolUsageImpl", { fg = h("@keyword").fg, bg = h("CursorLine").bg, italic = true })

    local function text_format(symbol)
      local res = {}

      -- local round_start = { "", "SymbolUsageRounding" }
      -- local round_end = { "", "SymbolUsageRounding" }

      -- Indicator that shows if there are any other symbols in the same line
      local stacked_functions_content = symbol.stacked_count > 0 and ("+%s"):format(symbol.stacked_count) or ""

      if symbol.references then
        local usage = symbol.references <= 1 and "usage" or "usages"
        local num = symbol.references == 0 and "no" or symbol.references
        table.insert(res, { "󰌹 ", "SymbolUsageRef" })
        table.insert(res, { ("%s %s"):format(num, usage), "SymbolUsageContent" })
      end

      if symbol.definition then
        if #res > 0 then
          table.insert(res, { " ", "NonText" })
        end
        table.insert(res, { "󰳽 ", "SymbolUsageDef" })
        table.insert(res, { symbol.definition .. " defs", "SymbolUsageContent" })
      end

      if symbol.implementation then
        if #res > 0 then
          table.insert(res, { " ", "NonText" })
        end
        table.insert(res, { "󰡱 ", "SymbolUsageImpl" })
        table.insert(res, { symbol.implementation .. " impls", "SymbolUsageContent" })
      end

      if stacked_functions_content ~= "" then
        if #res > 0 then
          table.insert(res, { " ", "NonText" })
        end
        table.insert(res, { " ", "SymbolUsageImpl" })
        table.insert(res, { stacked_functions_content, "SymbolUsageContent" })
      end

      return res
    end

    require("symbol-usage").setup({
      text_format = text_format,
    })
  end,
}
