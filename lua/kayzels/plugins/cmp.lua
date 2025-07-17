--- TODO: Add friendly snippets?

---@diagnostic disable: missing-fields
return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = "InsertEnter",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "folke/lazydev.nvim",
    },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- TODO: Sort out snippets
      appearance = {
        nerd_font_variant = "normal",
      },
      completion = {
        accept = {
          auto_brackets = { enabled = false },
        },
        list = {
          selection = {
            preselect = true,
            auto_insert = true,
          },
        },
        menu = {
          draw = {
            treesitter = { "lsp" },
            columns = {
              { "kind_icon", "split_icon" },
              { "label", "label_description", gap = 1 },
              { "kind" },
              -- { "source_name" },
            },
            components = {
              kind_icon = {
                ellipsis = false,
                text = function(ctx)
                  return ctx.kind_icon
                end,
              },
              split_icon = {
                ellipsis = false,
                text = function(_)
                  return "│"
                end,
                highlight = "BlinkCmpKindDefault",
              },
              kind = {
                ellipsis = true,
                text = function(ctx)
                  return ctx.icon_gap .. ctx.icon_gap .. "⟨" .. ctx.kind .. "⟩"
                end,
              },
              source_name = {
                text = function(ctx)
                  return "[" .. ctx.source_name .. "]"
                end,
                highlight = "BlinkCmpKindDefault",
              },
            },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = {
            border = "rounded",
          },
        },
        ghost_text = { enabled = true },
      },
      signature = {
        enabled = false,
        -- enabled = true
      },
      -- cmdline = {
      --   enabled = true
      -- },
      sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
          lsp = {
            fallbacks = {},
          },
          buffer = {
            score_offset = -10,
          },
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
        },
      },
      keymap = {
        preset = "default",
        ["<S-CR>"] = { "select_and_accept" },
        ["<S-Space>"] = { "hide" },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },
      },
    },
  },
  -- {
  --   "saghen/blink.cmp",
  --   opts = {
  --     sources = {
  --       default = { "lazydev" },
  --       providers = {
  --         lazydev = {
  --           name = "LazyDev",
  --           module = "lazydev.integrations.blink",
  --           score_offset = 100
  --         }
  --       }
  --     }
  --   }
  -- }
}
