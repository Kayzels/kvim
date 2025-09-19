---@class kayzels.utils.dap
local M = {}

---Jumps to the next breakpoint in the buffer
---@param dir "next"|"previous"
function M.go_to_breakpoint(dir)
  ---NOTE:Using this function until issue https://github.com/mfussenegger/nvim-dap/issues/1388 is resolved
  local breakpoints = require("dap.breakpoints").get()
  if #breakpoints == 0 then
    vim.notify("No breakpoints set", vim.log.levels.WARN)
    return
  end
  ---@type {bufnr: integer, line: integer}[]
  local points = {}
  for bufnr, buffer in pairs(breakpoints) do
    for _, point in ipairs(buffer) do
      table.insert(points, { bufnr = bufnr, line = point.line })
    end
  end

  local current = {
    bufnr = vim.api.nvim_get_current_buf(),
    line = vim.api.nvim_win_get_cursor(0)[1],
  }

  local next_point
  for i = 1, #points do
    local is_at_breakpoint_i = points[i].bufnr == current.bufnr and points[i].line == current.line
    if is_at_breakpoint_i then
      local next_idx = dir == "next" and i + 1 or i - 1
      if next_idx > #points then
        next_idx = 1
      end
      if next_idx == 0 then
        next_idx = #points
      end
      next_point = points[next_idx]
      break
    end
  end
  if not next_point then
    next_point = points[1]
  end

  vim.cmd(("buffer +%s %s"):format(next_point.line, next_point.bufnr))
end

return M
