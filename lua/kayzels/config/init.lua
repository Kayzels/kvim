_G.KyzVim = require("kayzels.utils")

local M = {}

function M.setup()
  require("kayzels.config.options")
  require("kayzels.lazy")
  require("kayzels.config.autocmds")
  require("kayzels.config.keymaps")

  KyzVim.format.setup()
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
