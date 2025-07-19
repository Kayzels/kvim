return {
  {
    "stevearc/conform.nvim",
    lazy = true,
    cmd = "ConformInfo",
    event = "BufWritePre",
    init = function()
      KyzVim.on_very_lazy(function()
        KyzVim.format.register({
          name = "conform.nvim",
          priority = 100,
          primary = true,
          format = function(buf)
            require("conform").format({ bufnr = buf })
          end,
          sources = function(buf)
            local ret = require("conform").list_formatters(buf)
            ---@param v conform.FormatterInfo
            return vim.tbl_map(function(v)
              return v.name
            end, ret)
          end,
        })
      end)
    end,
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
      default_format_opts = {
        timeout_ms = 3000,
        lsp_format = "fallback",
      },
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "black", lsp_format = "fallback" },
      },
      formatters = {
        injected = { options = { ignore_errors = true } },
      },
      -- format_on_save = function(bufnr)
      --   local ignore_filetypes = {}
      --   if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
      --     return
      --   end
      --   -- Disable with a global or buffer local variable
      --   if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      --     return
      --   end
      --   return {
      --     timeout_ms = 500,
      --     lsp_format = "fallback",
      --   }
      -- end,
      -- format_on_save = {
      --   timeout_ms = 500,
      --   lsp_format = "fallback",
      -- },
    },
    keys = {
      {
        "<leader>cF",
        function()
          require("conform").format({ formatters = { "injected" }, timeout = 3000 })
        end,
        mode = { "n", "v" },
        desc = "Format Injected Langs",
      },
      -- {
      --   "<leader>cf",
      --   function()
      --     require("conform").format({ async = true, lsp_format = "fallback" })
      --   end,
      --   desc = "Format file",
      -- },
    },
  },
}
