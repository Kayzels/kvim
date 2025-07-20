local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

local KTheme = KyzVim.theme
local lazy_color = KTheme.theme_for_mode[KTheme.mode_on_open]

require("lazy").setup({
  spec = {
    { import = "kayzels.plugins" },
    { import = "kayzels.plugins.ui" },
    { import = "kayzels.plugins.coding" },
    { import = "kayzels.plugins.editor" },
    { import = "kayzels.plugins.lang.json" },
    { import = "kayzels.plugins.lang.markdown" },
    { import = "kayzels.plugins.lang.python" },
    { import = "kayzels.plugins.ai.codecompanion" },
    { import = "kayzels.plugins.ai.copilot" },
  },
  rocks = {
    enabled = false,
  },
  checker = {
    enabled = true,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  install = {
    colorscheme = { lazy_color },
  },
  ui = {
    border = "rounded",
    backdrop = 100,
  },
})
