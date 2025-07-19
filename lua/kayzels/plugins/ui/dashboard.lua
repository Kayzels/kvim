return {
  {
    "snacks.nvim",
    ---@module 'snacks'
    ---@type snacks.config
    opts = {
      dashboard = {
        preset = {
          header = [[
██╗  ██╗██╗   ██╗███████╗██╗   ██╗██╗███╗   ███╗
██║ ██╔╝╚██╗ ██╔╝╚══███╔╝██║   ██║██║████╗ ████║
█████╔╝  ╚████╔╝   ███╔╝ ██║   ██║██║██╔████╔██║
██╔═██╗   ╚██╔╝   ███╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║
██║  ██╗   ██║   ███████╗ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═╝   ╚═╝   ╚══════╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
    ]],
          ---@type snacks.dashboard.Item[]
          keys = {
            {
              icon = " ",
              key = "f",
              desc = "Find File",
              action = ":lua Snacks.dashboard.pick('files')",
            },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            {
              icon = " ",
              key = "g",
              desc = "Find Text",
              action = ":lua Snacks.dashboard.pick('live_grep')",
            },
            { icon = " ", key = "p", desc = "Projects", action = ":lua Snacks.picker.projects()" },
            {
              icon = " ",
              key = "r",
              desc = "Recent Files",
              action = ":lua Snacks.dashboard.pick('oldfiles')",
            },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
      },
    },
  },
}
