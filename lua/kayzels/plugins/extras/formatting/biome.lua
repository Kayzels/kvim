local supported = {
  "astro",
  "css",
  "graphql",
  "javascript",
  "javascriptreact",
  "svelte",
  "typescript",
  "typescriptreact",
  "vue",
}

return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = { "biome" },
    },
  },
  {
    "conform.nvim",
    ---@module 'conform'
    ---@param opts conform.setupOpts
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      for _, ft in ipairs(supported) do
        opts.formatters_by_ft[ft] = opts.formatters_by_ft[ft] or {}
        table.insert(opts.formatters_by_ft[ft], "biome")
      end

      opts.formatters = opts.formatters or {}
      opts.formatters.biome = {
        require_cwd = true,
      }
    end,
  },
}
