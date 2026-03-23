---@class kayzels.utils.theme
local M = {}

---@alias KThemeMap { module: string, flavor: string }

---@type { dark: KThemeMap, light: KThemeMap }
local mode_map = {
  light = {
    module = "catppuccin",
    flavor = "catppuccin-nvim",
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
---Also creates an autocmd for switching the theme
---on the background option changing.
function M.setup()
  if vim.g.vscode then
    return
  end
  set_theme(vim.o.background)

  vim.api.nvim_create_autocmd("OptionSet", {
    group = vim.api.nvim_create_augroup("kyzvim_color_scheme", { clear = true }),
    pattern = "background",
    callback = function()
      set_theme(vim.o.background)
    end,
  })
end

return M
