return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    opts = {
      menu = {
        width = vim.api.nvim_win_get_width(0) - 4,
      },
      settings = {
        save_on_toggle = true,
      },
    },
    keys = function()
      local keys = {
        {
          "<leader>H",
          function()
            require("harpoon"):list():add()
          end,
          desc = "Harpoon File",
        },
        {
          "<leader>h",
          function()
            local harpoon = require("harpoon")
            harpoon.ui:toggle_quick_menu(harpoon:list())
          end,
          desc = "Harpoon Quick Menu",
        },
      }

      for i = 1, 9 do
        table.insert(keys, {
          "<leader>" .. i,
          function()
            require("harpoon"):list():select(i)
          end,
          desc = "Harpoon to File " .. i,
        })
      end
      return keys
    end,
  },
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    opts = {},
  },
  {
    "nvim-mini/mini.move",
    event = "VeryLazy",
    opts = {},
  },
  {
    "mikavilpas/yazi.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim", lazy = true },
    },
    cmd = {
      "Yazi",
      "Yazi cwd",
      "Yazi toggle",
    },
    keys = {
      {
        "<leader>e",
        mode = { "n", "v" },
        "<cmd>Yazi<cr>",
        desc = "Explorer Yazi (Root Dir)",
      },
      {
        "<leader>E",
        "<cmd>Yazi cwd<cr>",
        desc = "Explorer Yazi (cwd)",
      },
    },
    opts = {},
  },
  {
    "tiagovla/scope.nvim",
    event = "LazyFile",
    opts = {},
  },
}
