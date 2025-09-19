-- Terminal Mappings
local function term_nav(dir)
  ---@param self snacks.terminal
  return function(self)
    return self:is_floating() and "<c-" .. dir .. ">" or vim.schedule(function()
      vim.cmd.wincmd(dir)
    end)
  end
end

return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@module 'snacks'
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      quickfile = { enabled = true },
      lazygit = {
        configure = false,
      },
      scroll = {
        enabled = true,
      },
      terminal = {
        win = {
          keys = {
            nav_h = { "<C-h>", term_nav("h"), desc = "Go to Left Window", expr = true, mode = "t" },
            nav_j = { "<C-j>", term_nav("j"), desc = "Go to Lower Window", expr = true, mode = "t" },
            nav_k = { "<C-k>", term_nav("k"), desc = "Go to Upper Window", expr = true, mode = "t" },
            nav_l = { "<C-l>", term_nav("l"), desc = "Go to Right Window", expr = true, mode = "t" },
          },
        },
      },
    },
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    ---@module 'persistence'
    ---@type Persistence.Config
    opts = {},
    -- stylua: ignore
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
      { "<leader>qS", function() require("persistence").select() end,desc = "Select Session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    },
  },
  {
    "echasnovski/mini.hipatterns",
    event = "LazyFile",
    opts = function()
      local hi = require("mini.hipatterns")
      return {
        highlighters = {
          hex_color = hi.gen_highlighter.hex_color(),
          zero_x_hex = {
            pattern = "0x%x%x%x%x%x%x",
            ---@param _ any
            ---@param match string
            group = function(_, match)
              ---@type string
              local color = match:gsub("0x", "#")
              return MiniHipatterns.compute_hex_color_group(color, "bg")
            end,
          },
        },
      }
    end,
  },
  {
    "Aasim-A/scrollEOF.nvim",
    event = { "CursorMoved", "WinScrolled" },
    ---@type {pattern?:string, insert_mode?:boolean, floating?:boolean, disabled_filetypes?:string[], disabled_modes?:string[]}
    opts = {
      floating = false,
      insert_mode = false,
    },
  },
}
