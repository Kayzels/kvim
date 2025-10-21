local M = {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    ---@module 'noice'
    ---@type NoiceConfig
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      cmdline = {
        view = "cmdline",
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
      },
      presets = {
        bottom_search = true,
        -- command_palette = true,
        long_message_to_split = true,
        lsp_doc_border = true,
      },
    },
    keys = {
      { "<leader>sn", "", desc = "+noice" },
      {
        "<S-Enter>",
        function()
          require("noice").redirect(vim.fn.getcmdline())
        end,
        mode = "c",
        desc = "Redirect Cmdline",
      },
      {
        "<leader>snl",
        function()
          require("noice").cmd("last")
        end,
        desc = "Noice Last Message",
      },
      {
        "<leader>snh",
        function()
          require("noice").cmd("history")
        end,
        desc = "Noice History",
      },
      {
        "<leader>sna",
        function()
          require("noice").cmd("all")
        end,
        desc = "Noice All",
      },
      {
        "<leader>snd",
        function()
          require("noice").cmd("dismiss")
        end,
        desc = "Dismiss All",
      },
      {
        "<leader>snt",
        function()
          require("noice").cmd("pick")
        end,
        desc = "Noice Picker",
      },
      {
        "<c-f>",
        function()
          if not require("noice.lsp").scroll(4) then
            return "<c-f>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll Forward",
        mode = { "i", "n", "s" },
      },
      {
        "<c-b>",
        function()
          if not require("noice.lsp").scroll(-4) then
            return "<c-b>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll Backward",
        mode = { "i", "n", "s" },
      },
    },
    ---@param opts NoiceConfig
    config = function(_, opts)
      -- HACK: noice shows messages from before it was enabled,
      -- but this is not ideal when Lazy is installing plugins,
      -- so clear the messages in this case.
      if vim.o.filetype == "lazy" then
        vim.cmd([[messages clear]])
      end
      require("noice").setup(opts)
    end,
  },
  {
    "nvim-mini/mini.icons",
    opts = {
      default = {
        file = { glyph = "󰦪" },
      },
      filetype = {
        tcss = { glyph = "󰌜", hl = "MiniIconsAzure" },
      },
    },
    lazy = true,
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
  { "MunifTanjim/nui.nvim", lazy = true },
  { "grapp-dev/nui-components.nvim", dependencies = { "MunifTanjim/nui.nvim" }, lazy = true },
  {
    "folke/snacks.nvim",
    ---@module 'snacks'
    ---@type snacks.Config
    opts = {
      indent = { enabled = true },
      image = {
        enabled = true,
        doc = {
          enabled = true,
          float = false,
          inline = true,
        },
      },
      input = { enabled = true },
      notifier = { enabled = true },
      scope = { enabled = true },
      statuscolumn = { enabled = true },
      terminal = {
        win = {
          position = "float",
          border = "rounded",
        },
      },
      win = {
        backdrop = false,
      },
      words = { enabled = true },
    },
    keys = {
      {
        "<leader>n",
        function()
          Snacks.picker.notifications()
        end,
        desc = "Notification History",
      },
      {
        "<leader>un",
        function()
          Snacks.notifier.hide()
        end,
        desc = "Dismiss All Notifications",
      },
    },
  },
}

local names = { "dashboard", "lualine", "extras" }
KyzVim.plugin.extend_spec(M, "ui", names)

return M
