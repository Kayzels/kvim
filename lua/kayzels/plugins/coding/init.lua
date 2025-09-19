local M = {
  -- Auto pairs
  -- Automatically inserts a matching closing character
  -- when you type an opening character
  {
    "nvim-mini/mini.pairs",
    event = "VeryLazy",
    opts = {
      modes = { insert = true, command = false, terminal = false },
      -- skip autopair when next character is one of these
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      -- skip autopair when the cursor is inside these treesitter nodes
      -- skip_ts = { "string" },
      skip_ts = {},
      -- skip autopair when next character is closing pair
      -- and there are more closing pairs than opening pairs
      skip_unbalanced = false,
      -- better deal with markdown code blocks
      markdown = true,
      -- better deal with python docstrings and triple quotes
      python = true,
    },
    config = function(_, opts)
      KyzVim.mini.pairs(opts)
    end,
  },
  -- Improves comment syntax, lets Neovim handle multiple
  -- types of comments for a single language, and relaxes rules
  -- for uncommenting.
  {
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    opts = {},
  },
  -- Extends the `a`` & `i` text objects, adding the ability to select
  -- arguments, function calls, text within quotes and brackets,
  -- and repeat those selections.
  {
    "nvim-mini/mini.ai",
    event = "VeryLazy",
    opts = function()
      local ai = require("mini.ai")
      return {
        search_method = "cover_or_nearest",
        silent = false,
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({ -- code block
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
          d = { "%f[%d]%d+" }, -- digits
          e = { -- Word with case
            { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
            "^().*()$",
          },
          g = KyzVim.mini.ai_buffer,
          u = ai.gen_spec.function_call(), -- u for "Usage"
          U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
        },
      }
    end,
    config = function(_, opts)
      require("mini.ai").setup(opts)
      KyzVim.on_load("which-key.nvim", function()
        vim.schedule(function()
          KyzVim.mini.ai_whichkey(opts)
        end)
      end)
    end,
  },
  -- Configures LuaLS to support auto-completion and type checking
  -- while editing your Neovim configuration.
  {
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    ---@module 'lazydev'
    ---@type lazydev.Config
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "snacks.nvim", words = { "Snacks" } },
        { path = "KyzVim", words = { "KyzVim" } },
        -- TODO: Wezterm types library installation
      },
    },
  },
}

local names = { "extras", "textcase" }
KyzVim.plugin.extend_spec(M, "coding", names)

return M
