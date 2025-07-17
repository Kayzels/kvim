local M = {}

function M.setup()
  require("kayzels.config").setup()

  -- Setting this to be with an autocmd, to speed up loading
  vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufWritePre" }, {
    group = vim.api.nvim_create_augroup("LspLazyFile", { clear = true }),
    pattern = "*",
    once = true,
    callback = function()
      require("kayzels.lsp").setup()
    end,
  })
end

return M
