return {
  "mistweaverco/kulala.nvim",
  config = function()
    local ui = require("kulala.ui")

    require("kulala").setup({

      ui = {
        display_mode = "float",
      },
      kulala_keymaps = {
        ["Previous tab"] = {
          "<localleader>k",
          function()
            ui.show_previous_tab()
          end,
          mode = { "n" },
        },
        ["Next tab"] = {
          "<localleader>j",
          function()
            ui.show_next_tab()
          end,
          mode = { "n" },
        },
        ["Show headers"] = {
          "<localleader>h",
          function()
            ui.show_headers()
          end,
        },
        ["Show body"] = {
          "<localleader>b",
          function()
            ui.show_body()
          end,
        },
        ["Show headers and body"] = {
          "<localleader>a",
          function()
            ui.show_headers_body()
          end,
        },
        ["Show verbose"] = {
          "<localleader>v",
          function()
            ui.show_verbose()
          end,
        },
        ["Show script output"] = {
          "<localleader>o",
          function()
            ui.show_script_output()
          end,
        },
        ["Show stats"] = {
          "<localleader>s",
          function()
            ui.show_stats()
          end,
        },
        ["Show report"] = {
          "<localleader>r",
          function()
            ui.show_report()
          end,
        },
        ["Show filter"] = {
          "<localleader>f",
          function()
            ui.toggle_filter()
          end,
        },
        ["Clear responses history"] = {
          "<localleader>x",
          function()
            ui.clear_responses_history()
          end,
        },
      },
    })
  end,
}
