---@class kayzels.utils.theme
local M = {}

---@type 'dark'|'light'
M.mode_on_open = "dark"
local first_call = true

---@alias KThemeMap { module: string, flavor: string }

---@type { dark: KThemeMap, light: KThemeMap }
local mode_map = {
  light = {
    module = "catppuccin",
    flavor = "catppuccin-latte",
  },
  dark = {
    module = "tokyonight",
    flavor = "tokyonight-moon",
  },
}

---@type { dark: string, light: string }
M.theme_for_mode = {
  light = mode_map.light.flavor,
  dark = mode_map.dark.flavor,
}

---Set the theme that should be used, based on the mode
---@param mode 'light'|'dark'
local function set_theme(mode)
  require(mode_map[mode].module)
  vim.cmd.colorscheme(mode_map[mode].flavor)
end

---Set the theme that should be used.
---Only should be called once, and gets the value
---from `mode_on_open`, and then creates an autocmd.
---This is done to avoid needlessly loading the dark theme
---when in light mode
function M.setup()
  if vim.g.vscode or not first_call then
    return
  end
  first_call = false
  local mode = M.mode_on_open
  set_theme(mode)

  vim.api.nvim_create_autocmd("OptionSet", {
    group = vim.api.nvim_create_augroup("kyzvim_color_scheme", { clear = true }),
    pattern = "background",
    callback = function()
      local new_mode = vim.o.background
      set_theme(new_mode)
    end,
  })
end

return M
