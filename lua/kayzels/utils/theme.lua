local M = {}

function M.set_theme()
  local background = vim.opt.background:get()
  local light_theme = "catppuccin"
  local dark_theme = "tokyonight"
  if background == "dark" then
    vim.cmd.colorscheme(dark_theme)
  else
    vim.cmd.colorscheme(light_theme)
  end
end

return M
