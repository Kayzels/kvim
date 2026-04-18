---@class kayzels.utils.diagnostic
local M = {}

local current_min_sev = vim.diagnostic.severity.HINT

function M.set_config()
  local severity_cfg = { min = current_min_sev }

  ---@type vim.diagnostic.Opts
  local diagnostic_config = {
    underline = { severity = severity_cfg },
    update_in_insert = false,
    severity_sort = true,
    virtual_text = {
      spacing = 4,
      source = "if_many",
      severity = severity_cfg,
      prefix = function(diagnostic)
        local icons = KyzVim.icons.diagnostics
        for d, icon in pairs(icons) do
          if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
            return icon
          end
        end
        return "●"
      end,
    },
    signs = {
      severity = severity_cfg,
      text = {
        [vim.diagnostic.severity.ERROR] = KyzVim.icons.diagnostics.Error,
        [vim.diagnostic.severity.WARN] = KyzVim.icons.diagnostics.Warn,
        [vim.diagnostic.severity.HINT] = KyzVim.icons.diagnostics.Hint,
        [vim.diagnostic.severity.INFO] = KyzVim.icons.diagnostics.Info,
      },
    },
    float = {
      border = "rounded",
      source = true,
    },
  }

  vim.diagnostic.config(diagnostic_config)
end

function M.cycle_severity()
  if current_min_sev == vim.diagnostic.severity.ERROR then
    current_min_sev = vim.diagnostic.severity.HINT
  else
    current_min_sev = current_min_sev - 1
  end
  M.set_config()

  local level_name = ({ "Error", "Warn", "Info", "Hint" })[current_min_sev]
  Snacks.notify.info("Diagnostic filter: " .. level_name .. " and above", { title = "Diagnostic" })
end

return M
