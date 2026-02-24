vim.bo.shiftwidth = 4
vim.bo.tabstop = 4
vim.b.autoformat = false

_G.qml_indent = function()
  local line_num = vim.v.lnum
  local prev_lnum = vim.fn.prevnonblank(line_num - 1)
  if prev_lnum == 0 then
    return 0
  end

  local prev_line = vim.fn.getline(prev_lnum)
  local current_line = vim.fn.getline(line_num)
  local indent = vim.fn.indent(prev_lnum)
  local sw = vim.fn.shiftwidth()

  -- If the previous line ended with an opening brace, increase indent
  if prev_line:match("{%s*$") then
    indent = indent + sw
  end

  if current_line:match("^%s*}") then
    indent = indent - sw
  end

  return indent
end

vim.schedule(function()
  vim.bo.indentexpr = ""
  vim.bo.indentexpr = "v:lua.qml_indent()"
end)
