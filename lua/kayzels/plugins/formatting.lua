return {
  {
    "stevearc/conform.nvim",
    dependencies = { "mason.nvim" },
    lazy = true,
    cmd = "ConformInfo",
    -- event = "BufWritePre",
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
        async = false,
        quiet = false,
        lsp_format = "fallback",
      },
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
      },
      formatters = {
        injected = { options = { ignore_errors = true } },
      },
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
