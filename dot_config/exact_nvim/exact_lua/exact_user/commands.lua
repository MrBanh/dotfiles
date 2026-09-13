local usercmd = vim.api.nvim_create_user_command

usercmd("Btop", function()
  if vim.fn.executable("btop") == 1 then
    Snacks.terminal.toggle("btop", {
      win = {
        style = "terminal",
        width = 0,
        height = 0,
      },
    })
  else
    Snacks.notify.error("btop is not installed. Please install it to use this command.", {
      title = "Btop",
    })
  end
end, {
  desc = "Toggle btop in terminal",
})

usercmd("Gh", function()
  if vim.fn.executable("gh") == 1 then
    Snacks.terminal.toggle({ "gh", "dash" }, {
      win = {
        style = "terminal",
        width = 0,
        height = 0,
      },
    })
  else
    Snacks.notify.error("gh-dash is not installed. Please install it with: `gh extension install dlvhdr/gh-dash`", {
      title = "gh-dash",
    })
  end
end, {
  desc = "Toggle gh-dash in terminal",
})
