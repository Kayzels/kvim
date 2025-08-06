require("kayzels").setup()

-- Need to call explicitly after load, otherwise Lualine doesn't render
if not vim.g.vscode then
  KyzVim.theme.set_theme()
end
