return {
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "LazyFile",
    ---@module 'treesitter-context'
    ---@type fun():TSContext.UserConfig
    opts = function()
      local tsc = require("treesitter-context")
      Snacks.toggle({
        name = "Treesitter Context",
        get = tsc.enabled,
        set = function(state)
          if state then
            tsc.enable()
          else
            tsc.disable()
          end
        end,
      }):map("<leader>ut")
      ---@type TSContext.UserConfig
      local opts = {
        mode = "cursor",
        max_lines = 3,
      }
      return opts
    end,
  },
}
