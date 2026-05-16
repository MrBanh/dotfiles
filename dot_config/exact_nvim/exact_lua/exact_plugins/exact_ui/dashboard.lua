return {
  "folke/snacks.nvim",
  opts = {
    dashboard = {
      preset = {
        header = [[
          ████                      ████        
        ██░░░░██                  ██░░░░██      
        ██░░░░██                  ██░░░░██      
      ██░░░░░░░░██████████████████░░░░░░░░██    
      ██░░░░░░░░▓▓▓▓░░▓▓▓▓▓▓░░▓▓▓▓░░░░░░░░██    
      ██░░░░░░░░▓▓▓▓░░▓▓▓▓▓▓░░▓▓▓▓░░░░░░░░██    
    ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██  
    ██░░██░░░░████░░░░░░░░░░░░░░████░░░░██░░██  
    ██░░░░██░░████░░░░░░██░░░░░░████░░██░░░░██  
  ██░░░░██░░░░░░░░░░░░██████░░░░░░░░░░░░██░░░░██
  ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██
  ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██
  ██▓▓▓▓░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▓▓▓▓██
  ██▓▓▓▓░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▓▓▓▓██
  ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██
        ]],
      },
      sections = {
        { section = "header" },
        {
          icon = " ",
          desc = "Browse Repo",
          padding = 1,
          key = "b",
          action = function()
            Snacks.gitbrowse()
          end,
        },
        { section = "keys", gap = 0, padding = 1 },
        {
          icon = " ",
          title = "Recent Files",
          section = "recent_files",
          indent = 2,
          padding = 1,
        },
        function()
          local in_git = Snacks.git.get_root() ~= nil
          local cmds = {
            {
              icon = " ",
              title = "Git Status",
              cmd = "git --no-pager diff --stat -B -M -C",
              height = 5,
            },
          }
          return vim.tbl_map(function(cmd)
            return vim.tbl_extend("force", {
              section = "terminal",
              enabled = in_git,
              padding = 1,
              ttl = 5 * 60,
              indent = 3,
            }, cmd)
          end, cmds)
        end,
        { section = "startup" },
      },
    },
  },
}
