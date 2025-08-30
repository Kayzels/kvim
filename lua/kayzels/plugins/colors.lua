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
      float = {
        transparent = false,
        solid = false,
      },
      custom_highlights = function(colors)
        local cat_opts = require("catppuccin").options
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
          BlinkCmpGhostText = { link = "cmpGhostText" },
          Folded = { fg = colors.blue, bg = colors.surface0 },
          Comment = { fg = colors.overlay0, style = cat_opts.styles.comments },
          YankyPut = { link = "Search" },
          YankyYanked = { link = "IncSearch" },
          YaziFloat = { link = "NormalFloat" },
          ["@variable.builtin"] = { fg = colors.red, style = { "italic" } },
          ["@lsp.mod.global"] = { link = "@variable.builtin" },
          ["@lsp.typemod.variable.global"] = { link = "@variable.builtin" },
          CursorLine = { bg = colors.crust },
          WinSeparator = { fg = colors.overlay0 },

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
        neotest = true,
        neotree = true,
        noice = true,
        notify = true,
        render_markdown = true,
        semantic_tokens = true,
        snacks = {
          enabled = true,
          indent_scope_color = "lavender",
        },
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
        hl["@variable.builtin"] = { fg = c.red, italic = true }
        hl["@lsp.mod.global"] = hl["@variable.builtin"]
        hl["@lsp.typemod.variable.global"] = hl["@variable.builtin"]
      end,
    },
  },
  {
    "f-person/auto-dark-mode.nvim",
    cond = function()
      local current_term = os.getenv("TERM")
      return current_term ~= "xterm-kitty" and current_term ~= "xterm-ghostty"
    end,
    opts = {
      update_interval = 1000,
      set_dark_mode = function()
        vim.opt.background = "dark"
      end,
      set_light_mode = function()
        vim.opt.background = "light"
      end,
    },
  },
}
