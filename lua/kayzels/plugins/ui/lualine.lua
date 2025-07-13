return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "folke/trouble.nvim",
      "folke/snacks.nvim"
    },
    opts = function()
      local lualine_require = require("lualine_require")
      lualine_require.require = require

      local icons = require("kayzels.icons")

      local lualine_util = require("kayzels.utils.lualine")

      local opts = {
        options = {
          theme = "auto",
          section_separators = { left = "", right = "" },
          component_separators = "▎",
          disabled_filetypes = {
            tabline = { "neo-tree", "dashboard", "snacks_dashboard" },
            winbar = { "neo-tree", "dashboard", "snacks_dashboard" },
            statusline = { "dashboard", "snacks_dashboard" },
          },
          always_show_tabline = true,
        },
        sections = {
          lualine_a = {
            { "mode", separator = { left = "" }, right_padding = 2, color = { gui = "bold" } },
          },
          lualine_b = {
            {
              function ()
                return vim.fs.basename(require("kayzels.utils.root").cwd())
              end,
              padding = { left = 2, right = 2},
              color = nil,
            },
            { "branch", padding = { left = 1, right = 1 } },
          },
          lualine_c = {
            lualine_util.root_dir(),
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              }
            },
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            { lualine_util.pretty_path() }
          },
          lualine_x = {
            Snacks.profiler.status(),
            -- stylua: ignore
            {
              function() return require("noice").api.status.mode.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
              color = function() return { fg = Snacks.util.color("Constant") } end,
            },
            -- stylua: ignore
            {
              function() return "  " .. require("dap").status() end,
              cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
              color = function() return { fg = Snacks.util.color("Debug") } end,
            },
            -- stylua: ignore
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = function() return { fg = Snacks.util.color("Special") } end,
            },
            {
              "diff",
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
              source = function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end,
            },
          },
          lualine_y = { "progress" },
          lualine_z = { { "location", separator = { right = "" }, left_padding = 1 } },
        },
        tabline = {
          lualine_a = lualine_util.create_tab_component("tabs"),
          lualine_z = lualine_util.create_tab_component("buffers")
        },
        winbar = {
          lualine_a = lualine_util.create_fname_bar(true)
        },
        inactive_winbar = {
          lualine_b = lualine_util.create_fname_bar(false)
        },
        extensions = {
          "lazy",
          "mason",
          -- "neo-tree",
          -- "nvim-dap-ui",
          "quickfix",
          "trouble",
          -- "fzf"
        }
      }
      return opts
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local MIN_WIDTH = 120
      local conditions = {
        hide_in_width = function()
          return vim.opt.co:get() > MIN_WIDTH
        end,
      }

      local lsp = {
        ---@return string
        function()
          local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
          if #buf_clients == 0 then
            return "LSP Inactive"
          end

          local buf_client_names = {}
          for _, client in pairs(buf_clients) do
            if not vim.tbl_contains(vim.g.root_lsp_ignore, client.name) then
            -- if client.name ~= "copilot" then
              table.insert(buf_client_names, client.name)
            end
          end

          if #buf_client_names == 1 then
            local language_servers = buf_client_names[1]
            return language_servers
          end

          local unique_client_names = table.concat(buf_client_names, ", ")
          local language_servers = string.format("[%s]", unique_client_names)

          return language_servers
        end,
        cond = conditions.hide_in_width,
      }
      table.insert(opts.sections.lualine_x, lsp)
      local ft_table = {
        "filetype",
        padding = { left = 1, right = 1 },
        icon = { align = "right" },
        cond = conditions.hide_in_width,
      }
      table.insert(opts.sections.lualine_x, ft_table)
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      ---@alias LualineSeparator {left?: string, right?: string}
      ---@param ext_name string
      ---@param section_separators table<string, LualineSeparator>
      local function set_extension_separators(ext_name, section_separators)
        for i, ext in ipairs(opts.extensions or {}) do
          if ext == ext_name then
            local ext_table = require("lualine.extensions." .. ext_name)
            for section, sep_tbl in pairs(section_separators) do
              if ext_table.sections and ext_table.sections[section] and ext_table.sections[section][1] then
                local orig = ext_table.sections[section][1]
                ext_table.sections[section] = {
                  {
                    orig,
                    separator = sep_tbl
                  }
                }
              end
            end
            opts.extensions[i] = ext_table
          end
        end
      end

      set_extension_separators("lazy", { lualine_a = { left = "" } })
      set_extension_separators("mason", { lualine_a = { left = "" } })
      -- set_extension_separators("neo-tree", { lualine_a = { left = "", right = "" } })
      -- set_extension_separators("fzf", { lualine_a = { left = "", right = "" }, lualine_z = { right = "" } })
      set_extension_separators("quickfix", { lualine_a = { left = "" }, lualine_z = { left = "", right = ""} })
    end,
  },
}
