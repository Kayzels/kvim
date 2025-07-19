-- TODO: Snacks picker add way to do horizontal split with C-x
return {
  {
    "folke/snacks.nvim",
    ---@module 'snacks'
    ---@type snacks.Config
    opts = {
      picker = {
        ui_select = true,
        formatters = {
          file = {
            filename_first = true,
          },
        },
        win = {
          input = {
            keys = {
              ["<a-c>"] = {
                "toggle_cwd",
                mode = { "n", "i" },
              },
            },
          },
        },
        actions = {
          ---@param p snacks.Picker
          toggle_cwd = function(p)
            local root = KyzVim.root({ buf = p.input.filter.current_buf, normalize = true })
            local cwd = vim.fs.normalize(vim.uv.cwd() or ".")
            local current = p:cwd()
            p:set_cwd(current == root and cwd or root)
            p:find()
          end,
        },
      },
    },
    -- stylua: ignore
    keys = {
      { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
      { "<leader><space>", function() Snacks.picker.files() end, desc = "Find Files (Root Dir)" },
      { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
      -- find
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>fB", function() Snacks.picker.buffers({ hidden = true, nofile = true}) end, desc = "Buffers (all)" },
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files (Root Dir)" },
      { "<leader>fF", function() Snacks.picker.files({ cwd = KyzVim.root.cwd() }) end, desc = "Find Files (cwd)" },
      { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Files (git files)" },
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
      { "<leader>fR", function() Snacks.picker.recent({filter = {cwd = true}}) end, desc = "Recent (cwd)" },
      { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
      -- git
      { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (hunks)" },
      { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
      { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
      -- Grep
      { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
      { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
      { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep (Root Dir)" },
      { "<leader>sG", function() Snacks.picker.grep({ cwd = KyzVim.root.cwd()}) end, desc = "Grep (cwd)" },
      { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Plugin Spec" },
      { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word (Root Dir)", mode = { "n", "x" } },
      { "<leader>sW", function() Snacks.picker.grep_word({ cwd = KyzVim.root.cwd() }) end, desc = "Visual selection or word (cwd)", mode = { "n", "x" } },

      -- search
      { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
      { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
      { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
      { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
      { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
      { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
      { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
      { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
      { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
      { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
      { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
      { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
      { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
      { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
      { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
      { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
      { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
      { "<leader>su", function() Snacks.picker.undo() end, desc = "Undotree" },
      -- ui
      { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
    },
  },
  {
    "folke/todo-comments.nvim",
    -- stylua: ignore
    keys = {
      -- { "<leader>st", function() Snacks.picker.todo_comments() end, desc = "Todo" },
      { "<leader>st", function() Snacks.picker("todo_comments") end, desc = "Todo" },
      -- { "<leader>sT", function () Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } }) end, desc = "Todo/Fix/Fixme" },
      { "<leader>sT", function () Snacks.picker("todo_comments", { keywords = {"TODO", "FIX", "FIXME"}}) end, desc = "Todo/Fix/Fixme" },
    },
  },
  {
    "folke/snacks.nvim",
    ---@param opts snacks.Config
    ---@return snacks.Config
    opts = function(_, opts)
      if KyzVim.has("trouble.nvim") then
        return vim.tbl_deep_extend("force", opts or {}, {
          picker = {
            actions = {
              trouble_open = function(...)
                return require("trouble.sources.snacks").actions.trouble_open.action(...)
              end,
            },
            win = {
              input = {
                keys = {
                  ["<a-t>"] = {
                    "trouble_open",
                    mode = { "n", "i" },
                  },
                },
              },
            },
          },
        })
      end
      return opts
    end,
  },
  -- {
  --   "folke/snacks.nvim",
  --   ---@param opts snacks.Config
  --   opts = function(_, opts)
  --     table.insert(opts.dashboard.preset.keys, 3, {
  --       icon = "",
  --       key = "p",
  --       desc = "Projects",
  --       action = ":lua Snacks.picker.projects()",
  --     })
  --   end,
  -- },
}
