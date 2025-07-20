---@class kayzels.utils.tabout
---@overload fun(opts?: {reverse?:boolean})
local M = setmetatable({}, {
  __call = function(m, ...)
    return m.tabout(...)
  end,
})

---Goes to the next character after a closing pair.
---If reverse is true, goes back over the previous closing pair,
---or the nearest opening pair, whichever is closer.
---@param opts? {reverse?:boolean}
function M.tabout(opts)
  opts = opts or {}
  local reverse = opts.reverse or false
  local current_row = vim.api.nvim_win_get_cursor(0)[1]

  -- Cannot use pure search way, because it doesn't put the cursor after the match,
  -- event with the e flag set, in Insert mode
  -- So, use searchpos for matching location. Don't use that to move cursor,
  -- as that has the same issue.
  -- Instead, if there is a match, explicitly set cursor position.
  -- Only needs to be done explicitly for forward, not for reverse.

  local forward_pattern = "[})\\]\"'>`]"
  local forward_flags = "cnz" -- c: include current, n: don't go to match, z: start at cursor

  local backward_pattern = "[{}()\\[\\]\"'<>`]"
  local backward_flags = "b" -- b: backwards

  local pattern = reverse and backward_pattern or forward_pattern
  local flags = reverse and backward_flags or forward_flags

  local match_row, match_col = unpack(vim.fn.searchpos(pattern, flags, current_row))

  -- If doing a forward search, need to explicitly set position.
  -- Only should be set if valid result, which means the match from searchpos isn't (0, 0)
  if not reverse and match_row ~= 0 then
    vim.api.nvim_win_set_cursor(0, { match_row, match_col })
  end
end

return M
