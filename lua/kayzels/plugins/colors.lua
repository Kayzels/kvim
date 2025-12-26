return {
  {
    "catppuccin/nvim",
    priority = 1000,
    lazy = true,
    name = "catppuccin",
    ---@module 'catppuccin'
    ---@type CatppuccinOptions
    opts = {
      lsp_styles = {
        enabled = true,
        underlines = {
          errors = { "undercurl" },
          hints = { "undercurl" },
          warnings = { "undercurl" },
          information = { "undercurl" },
        },
      },
      transparent_background = false,
      styles = {
        comments = { "italic" },
        conditionals = {},
        keywords = {},
        functions = { "bold" },
      },
      float = {
        transparent = false,
        solid = false,
      },
      custom_highlights = function(colors)
        local cat_opts = require("catppuccin").options
        local groups = {
          cmpGhostText = { fg = colors.surface2 },
          BlinkCmpGhostText = { link = "cmpGhostText" },
          Folded = { fg = colors.blue, bg = colors.surface0 },
          Comment = { fg = colors.overlay1, style = cat_opts.styles.comments },
          YankyPut = { link = "Search" },
          YankyYanked = { link = "IncSearch" },
          YaziFloat = { link = "NormalFloat" },
          ["@variable.builtin"] = { fg = colors.red, style = { "italic" } },
          ["@lsp.mod.global"] = { link = "@variable.builtin" },
          ["@lsp.typemod.variable.global"] = { link = "@variable.builtin" },
          WinSeparator = { fg = colors.overlay0 },
          SnacksNormal = { link = "NormalFloat" },
          ["@lsp.type.enumMember"] = { fg = colors.peach },
          RenderMarkdownCodeInline = { bg = colors.crust },
          RenderMarkdownKbdElement = { bg = colors.crust, fg = colors.lavender },
          RenderMarkdownQuote1 = { bg = colors.crust },
          ["@markup.quote.markdown"] = { fg = colors.text },

          -- Old colors that have been replaced
          ["@variable.member"] = { fg = colors.lavender },
          ["@module"] = { fg = colors.lavender, style = cat_opts.styles.miscs or { "italic" } },
          ["@string.special.url"] = { fg = colors.teal, style = { "italic", "underline" } },
          ["@markup.link.url"] = { fg = colors.teal, style = { "italic", "underline" } },
          ["@type.builtin"] = { fg = colors.yellow, style = cat_opts.styles.properties or { "italic" } },
          ["@property"] = { fg = colors.lavender, style = cat_opts.styles.properties or {} },
          ["@constructor"] = { fg = colors.sapphire },
          ["@tag"] = { fg = colors.mauve },
          ["@tag.attribute"] = { fg = colors.teal, style = cat_opts.styles.miscs or { "italic" } },
          ["@tag.delimiter"] = { fg = colors.sky },
          ["@property.css"] = { fg = colors.lavender },
          ["@property.id.css"] = { fg = colors.blue },
          ["@type.tag.css"] = { fg = colors.mauve },
          ["@markup.raw"] = { fg = colors.teal },
        }
        return groups
      end,
      integrations = {
        blink_cmp = {
          style = "bordered",
        },
        cmp = true,
        flash = true,
        gitsigns = true,
        lsp_trouble = true,
        mason = true,
        mini = true,
        neotest = true,
        neotree = true,
        noice = true,
        notify = true,
        octo = true,
        render_markdown = true,
        snacks = {
          enabled = true,
          indent_scope_color = "lavender",
        },
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
        hl["@variable.builtin"] = { fg = c.red, italic = true }
        hl["@lsp.mod.global"] = hl["@variable.builtin"]
        hl["@lsp.typemod.variable.global"] = hl["@variable.builtin"]
        hl["@markup.raw.markdown_inline"] = { bg = c.terminal_black }
        hl["@markup.strong"] = { bold = true, fg = c.blue }
        hl.RenderMarkdownKbdElement = { bg = c.bg_dark1, fg = c.yellow }
      end,
    },
  },
  {
    "vimpostor/vim-lumen",
    cond = function()
      local current_term = os.getenv("TERM")
      return current_term ~= "xterm-kitty" and current_term ~= "xterm-ghostty"
    end,
    config = function()
      KTheme = KyzVim.theme
      vim.g.lumen_light_colorscheme = KTheme.theme_for_mode.light
      vim.g.lumen_dark_colorscheme = KTheme.theme_for_mode.dark
      vim.g.lumen_startup_overwrite = 0
    end,
  },
}
