-- https://github.com/anuvyklack/pretty-fold.nvim

return {
  "anuvyklack/pretty-fold.nvim",
  event = "BufReadPost",
  config = function()
    require("pretty-fold").setup {
      keep_indentation = false,
      fill_char = " ",
      sections = {
        left = {
          function()
            -- Calculate the fold level and return the appropriate string
            local level = vim.v.foldlevel
            if level == 0 then
              return "󰁚 "
            else
              return string.rep("  ", level - 1) .. "󰁚 "
            end
          end,
          "content",
        },
        right = {
          "󰁂 ",
          "number_of_folded_lines",
        },
      },
    }
  end,
}
