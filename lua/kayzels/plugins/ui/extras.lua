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
  {
    "sphamba/smear-cursor.nvim",
    cond = not vim.g.neovide,
    opts = function()
      local smear = require("smear_cursor")
      Snacks.toggle({
        name = "Smear Cursor",
        set = function()
          smear.toggle()
        end,
        get = function()
          return smear.enabled
        end,
      }):map("<leader>uo")
      return {
        enabled = true,
        smear_insert_mode = false,
        min_horizontal_distance_smear = 4,
        min_vertical_distance_smear = 3,
        -- smear_between_neighbor_lines = false,
        -- legacy_computing_symbols_support = true,
        -- legacy_computing_symbols_support_vertical_bars = true,
        -- smear_to_cmd = false,
        hide_target_hack = true,
        cursor_color = "none",
      }
    end,
    -- NOTE: Not sure of the GPU impact of this...
  },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    opts = {
      options = {
        use_icons_from_diagnostic = true,
        set_arrow_to_diag_color = true,
        show_source = {
          if_many = true,
        },
      },
    },
    config = function(_, opts)
      vim.diagnostic.config({ virtual_text = false })
      require("tiny-inline-diagnostic").setup(opts)
    end,
  },
}
