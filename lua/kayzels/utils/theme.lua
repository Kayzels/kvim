---@class kayzels.utils.theme
local M = {}

---@type 'dark'|'light'
M.mode_on_open = "light"
local first_call = true

M.theme_for_mode = {
  light = "catppuccin",
  dark = "tokyonight",
}

---Set the theme that should be used, based on the mode
---On first call, it doesn't use the Neovim set value, but the
---value of `mode_on_open`.
---This is done to avoid needlessly loading the dark theme
---when in light mode
function M.set_theme()
  ---@type 'dark'|'light'
  local mode
  if first_call then
    mode = M.mode_on_open
    first_call = false
  else
    mode = vim.opt.background:get()
  end

  require(M.theme_for_mode[mode])
  vim.cmd.colorscheme(M.theme_for_mode[mode])
end

return M
