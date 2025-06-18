return {
  {
    'zbirenbaum/copilot.lua',
    build = ':Copilot auth',
    event = { 'InsertEnter', 'BufReadPost' },
    cmd = { 'Copilot' },
    opts = {
      suggestion = {
        enabled = false,
        hide_during_completion = false,
        auto_trigger = true,
        keymap = {
          accept = false, -- handled by cmp
          next = '<M-]>',
          prev = '<M-[>',
          dismiss = '<C-c>',
        },
      },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
  },
  { 'fang2hou/blink-copilot' },
  {
    'saghen/blink.cmp',
    optional = true,
    dependencies = { 'fang2hou/blink-copilot' },
    opts = {
      sources = {
        default = { 'copilot' },
        providers = {
          copilot = {
            name = 'copilot',
            module = 'blink-copilot',
            score_offset = 100,
            async = true,
          },
        },
      },
    },
  },
}
