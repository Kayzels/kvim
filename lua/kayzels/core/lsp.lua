vim.lsp.enable({"lua_ls"})

-- Set up signs
vim.diagnostic.config({
  underline = true,
  virtual_text = {
    spacing = 4,
    source = "if_many",
    prefix = "●",
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = require("kayzels.icons").diagnostics.Error,
      [vim.diagnostic.severity.WARN] = require("kayzels.icons").diagnostics.Warn,
      [vim.diagnostic.severity.HINT] = require("kayzels.icons").diagnostics.Hint,
      [vim.diagnostic.severity.INFO] = require("kayzels.icons").diagnostics.Info,
    }
  },
  float = {
    border = "rounded",
    source = true,
  },
  update_in_insert = false,
  severity_sort = true,
})

-- TODO: Get lazydev and types to work for Lua
