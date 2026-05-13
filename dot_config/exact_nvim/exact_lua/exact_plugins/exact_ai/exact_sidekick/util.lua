-- ---------------------------------------------------------------------------
-- Sidekick helpers used from the plugin spec.
-- ---------------------------------------------------------------------------

local M = {}

---Build a location context (used by {this}/{position}/{line}/{file}) without
---the leading space that sidekick.nvim inserts before `:L<row>`.
---Upstream renders `@file :L91`; we want `@file:L91` so AI clients can
---treat the whole token as one reference.
---@param kind "file"|"line"|"position"
function M.loc_context(kind)
  return function(ctx)
    local Loc = require("sidekick.cli.context.location")
    if not Loc.is_file(ctx.buf) then
      return false
    end
    local text = Loc.get(ctx, { kind = kind })
    -- text is sidekick.Text[][] — strip a stand-alone " " segment that sits
    -- right before the ":" delimiter.
    for _, line in ipairs(text) do
      for i = #line - 1, 1, -1 do
        if line[i] and line[i][1] == " " and line[i + 1] and line[i + 1][1] == ":" then
          table.remove(line, i)
        end
      end
    end
    return text
  end
end

return M
