---@class kayzels.utils.diagnostic
local M = {}

local current_min_sev = vim.diagnostic.severity.HINT

local function refresh_severity()
  local severity_cfg = { min = current_min_sev }

  vim.diagnostic.config({
    underline = { severity = severity_cfg },
    signs = { severity = severity_cfg },
    virtual_text = { severity = severity_cfg },
  })

  local level_name = ({ "Error", "Warn", "Info", "Hint" })[current_min_sev]
  Snacks.notify.info("Diagnostic filter: " .. level_name .. " and above", { title = "Diagnostic" })
end

function M.cycle_severity()
  if current_min_sev == vim.diagnostic.severity.ERROR then
    current_min_sev = vim.diagnostic.severity.HINT
  else
    current_min_sev = current_min_sev - 1
  end
  refresh_severity()
end

return M
