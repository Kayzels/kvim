return {
  {
    "catppuccin/nvim",
    priority = 1000,
    lazy = true,
    name = "catppuccin",
    ---@module 'catppuccin'
    ---@type CatppuccinOptions
    opts = {
      transparent_background = false,
      styles = {
        comments = { "italic" },
        conditionals = {},
        keywords = {},
        functions = { "bold" },
      },
      custom_highlights = function(colors)
        local groups = {
          cmpGhostText = { fg = colors.surface0 },
          BlinkCmpMenuSelection = { link = "PmenuSel" },
          -- BlinkCmpMenu = { link = "Normal" },
          -- BlinkCmpMenuBorder = { bg = colors.none, fg = colors.text },
          BlinkCmpGhostText = { fg = colors.surface0 },
          Folded = { fg = colors.blue, bg = colors.surface0 },
          Comment = { fg = colors.overlay0, style = { "italic" } },
          YankyPut = { link = "Search" },
          YankyYanked = { link = "IncSearch" },
        }
        return groups
      end,
      integrations = {
        blink_cmp = true,
        cmp = true,
        flash = true,
        gitsigns = true,
        lsp_trouble = true,
        mason = true,
        markdown = true,
        mini = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        neotree = true,
        noice = true,
        notify = true,
        render_markdown = true,
        semantic_tokens = true,
        snacks = true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
    },
  },
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    lazy = true,
    ---@module 'tokyonight'
    ---@type tokyonight.Config
    opts = {
      style = "moon",
      styles = {
        comments = { italic = true },
        keywords = { italic = false },
        functions = { bold = true },
        variables = {},
      },
      lualine_bold = true,
      on_colors = function(colors)
        local git_add = colors.green
        local git_change = colors.blue1
        local git_delete = colors.red
        colors.git.add = git_add
        colors.git.change = git_change
        colors.git.delete = git_delete
        colors.bg_statusline = colors.none
      end,
      on_highlights = function(hl, c)
        hl.VertSplit = {
          fg = c.border_highlight,
        }
        hl.WinSeparator = {
          fg = c.border_highlight,
        }
        hl.ColorColumn = {
          bg = c.bg_highlight,
        }
        hl.Folded = {
          bg = c.bg_dark,
        }
        hl["@module"] = {
          fg = c.yellow,
        }
        hl["@lsp.type.namespace.python"] = { link = "@module" }
        hl["@text.title"] = {
          bold = true,
          fg = c.blue,
        }
        hl["@text.property"] = {
          fg = c.yellow,
        }
        hl.lualine_c_normal = "NONE"
        hl.lualine_c_inactive = "NONE"
        hl.TelescopeSelection = hl.Visual
        hl.TabLineFill = "NONE"
        hl.BlinkCmpMenuSelection = hl.PmenuSel
        hl.BlinkCmpScrollBarThumb = hl.PmenuThumb
      end,
    },
  },
}
