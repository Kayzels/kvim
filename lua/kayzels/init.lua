local M = {}

local lsp_setup = false

function M.setup()
  require("kayzels.config").setup()

  -- Setting this to be with an autocmd, to speed up loading
  vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
    group = vim.api.nvim_create_augroup("LspLazyFile", { clear = true }),
    pattern = "*",
    once = true,
    callback = function()
      if not lsp_setup then
        require("kayzels.lsp").setup()
        lsp_setup = true
      end
    end,
  })
end

return M
