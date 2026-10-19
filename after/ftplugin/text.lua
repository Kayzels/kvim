---@return string | number
function _G.HeaderIndentFold()
  local line = vim.fn.getline(vim.v.lnum)

  -- Blank lines retain the fold level of the previous line
  if line:match("^%s*$") then
    return "="
  end

  local current_indent = vim.fn.indent(vim.v.lnum)
  local next_lnum = vim.fn.nextnonblank(vim.v.lnum + 1)

  if next_lnum == 0 then
    return math.floor(current_indent / vim.bo.shiftwidth)
  end

  local next_indent = vim.fn.indent(next_lnum)

  -- If the next line is indented deeper, start a new fold here (e.g. '>1')
  if next_indent > current_indent then
    return ">" .. math.floor((next_indent / vim.bo.shiftwidth))
  end

  return math.floor(current_indent / vim.bo.shiftwidth)
end

vim.opt_local.foldmethod = "expr"
vim.opt_local.foldexpr = "v:lua.HeaderIndentFold()"
