return {
  "mikavilpas/yazi.nvim",
  cmd = { "Yazi" },
  keys = {
    {
      "-",
      "<cmd>Yazi<cr>",
      desc = "Open yazi at the current file",
    },
    {
      "_",
      "<cmd>Yazi cwd<cr>",
      desc = "Open the file manager in nvim's working directory",
    },
    {
      "<leader>-",
      "<cmd>Yazi toggle<cr>",
      desc = "Resume the last Yazi session",
    },
  },
  opts = {
    enable_mouse_support = true,
    keymaps = {
      show_help = "g?",
      open_file_in_horizontal_split = "<c-s>",
      open_file_in_vertical_split = "<c-v>",
      open_file_in_tab = "<c-t>",
      grep_in_directory = nil,
      replace_in_directory = "<c-g>",
      cycle_open_buffers = "]b",
      copy_relative_path_to_selected_files = "<c-y>",
      send_to_quickfix_list = "<c-q>",
      change_working_directory = "<localleader>c",
    },
  },
}
