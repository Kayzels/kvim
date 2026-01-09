_G.KyzVim = require("kayzels.utils")

local M = {}

---Make all keymaps silent by default
local function override_keymap_set()
  local keymap_set = vim.keymap.set

  ---@diagnostic disable-next-line: duplicate-set-field
  vim.keymap.set = function(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.silent = opts.silent ~= false
    return keymap_set(mode, lhs, rhs, opts)
  end
end

function M.setup()
  override_keymap_set()
  require("kayzels.config.options")
  require("kayzels.lazy")
  require("kayzels.config.autocmds")
  require("kayzels.config.keymaps")

  KyzVim.format.setup()
  KyzVim.root.setup()
  KyzVim.theme.setup()
  KyzVim.neovide.setup()
  if vim.g.vscode then
    vim.api.nvim_exec_autocmds("User", {
      pattern = "VSCodeVimKeymaps",
    })
  end
end

M.did_init = false
function M.init()
  if M.did_init then
    return
  end
  M.did_init = true

  -- delay notifications till vim.notify repalced or after 500 ms
  KyzVim.lazy_notify()

  -- hide deprecation warnings
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.deprecate = function() end

  -- setup event handlers for plugins
  KyzVim.plugin.setup()
end

return M
