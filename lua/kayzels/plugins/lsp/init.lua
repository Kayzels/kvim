return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      -- { "mason-org/mason-lspconfig.nvim", opts = {} }
    },
    event = {"BufReadPost", "BufNewFile", "BufWritePre"},
    -- opts = function()
    --   local ret = {
    --     diagnostics = {
    --       underline = true,
    --       update_in_insert = false,
    --       virtual_text = {
    --         spacing = 4,
    --         source = "if_many",
    --         prefix = "●"
    --       },
    --       severity_sort = true,
    --       signs = {
    --         text = {
    --           [vim.diagnostic.severity.ERROR] = require("kayzels.icons").diagnostics.Error,
    --           [vim.diagnostic.severity.WARN] = require("kayzels.icons").diagnostics.Warn,
    --           [vim.diagnostic.severity.HINT] = require("kayzels.icons").diagnostics.Hint,
    --           [vim.diagnostic.severity.INFO] = require("kayzels.icons").diagnostics.Info,
    --         },
    --       },
    --     },
    --     inlay_hints = {
    --       enabled = true
    --     },
    --     codelens = {
    --       enabled = false
    --     },
    --     capabilities = {
    --       workspace = {
    --         fileOperations = {
    --           didRename = true,
    --           willRename = true,
    --         },
    --       },
    --     },
    --     -- TODO: Formatting
    --   }
    --   return ret
    -- end
  }
}
