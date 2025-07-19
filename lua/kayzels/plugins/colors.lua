return {
  {
    "catppuccin/nvim",
    priority = 1000,
    lazy = true,
    name = "catppuccin",
    ---@module 'catppuccin'
    ---@type CatppuccinOptions
    opts = {
      transparent_background = true,
      styles = {
        comments = { "italic" },
        conditionals = {},
        keywords = {},
        functions = { "bold" },
      },
      custom_highlights = function(colors)
        local groups = {
          LspReferenceText = { bg = colors.surface0 },
          LspReferenceRead = { bg = colors.surface0 },
          LspReferenceWrite = { bg = colors.surface0 },
          --- This has the bg set because that makes it easier to differentiate
          --- and also allows it to be used in cmdline
          --- without the ghost text being impossible to read.
          --- The earlier value of colors.surface0 for the fg worked
          --- because it was automatically highlighted in the background
          --- because of Snacks.words, which uses the LspReference hihglighting.
          cmpGhostText = { fg = colors.overlay0, bg = colors.surface0 },
          BlinkCmpMenuSelection = { link = "PmenuSel" },
          BlinkCmpGhostText = { link = "cmpGhostText" },
          Folded = { fg = colors.blue, bg = colors.surface0 },
          Comment = { fg = colors.overlay0, style = { "italic" } },
          YankyPut = { link = "Search" },
          YankyYanked = { link = "IncSearch" },
          NormalFloat = { bg = colors.mantle, fg = colors.text },
          FloatBorder = { fg = colors.blue, bg = colors.mantle },
          YaziFloat = { link = "NormalFloat" },
          NeoTreeNormal = { fg = colors.text, bg = colors.mantle },
          NeoTreeNormalNC = { fg = colors.text, bg = colors.mantle },
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
      transparent = true,
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
        hl.YaziFloat = hl.NormalFloat
      end,
    },
  },
}
