local ok, gh_actions = pcall(require, "snacks.gh.actions")
if not ok then
  return
end

gh_actions.actions.open_in_diffview = {
  desc = "Open PR in Diffview",
  icon = "󰊢",
  type = "pr",
  priority = 150,
  action = function(item)
    vim.notify("Fetching latest refs...", vim.log.levels.INFO)

    vim.system({ "git", "fetch", "origin" }, {}, function(result)
      vim.schedule(function()
        if result.code ~= 0 then
          vim.notify("Failed to fetch: " .. result.stderr, vim.log.levels.ERROR)
          return
        end

        local diff_range = string.format("origin/%s...origin/%s", item.baseRefName, item.headRefName)
        vim.cmd("DiffviewOpen " .. diff_range)

        vim.g.current_pr = {
          repo = item.repo,
          number = item.number,
          base = item.baseRefName,
          head = item.headRefName,
        }

        vim.notify(string.format("Opened PR #%d in Diffview", item.number))
      end)
    end)
  end,
}
