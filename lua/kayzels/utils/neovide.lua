---@class kayzels.utils.neovide
local M = {}

function M.setup()
  if vim.g.neovide then
    vim.g.neovide_text_gamma = 2.0
    vim.g.neovide_text_constrast = 1.0
  end
end

return M
