---@diagnostic disable: missing-fields
return {
  {
    "zbirenbaum/copilot.lua",
    cmd = {
      "Copilot",
      "CodeCompanion",
      "CodeCompanionChat",
      "CodeCompanionCmd",
      "CodeCompanionActions",
    },
    build = ":Copilot auth",
    -- event = "BufReadPost",
    dependencies = {
      "folke/snacks.nvim",
    },
    ---@module 'copilot'
    ---@type CopilotConfig
    opts = {
      panel = {
        enabled = false,
      },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
    keys = {
      -- Copilot is disabled by default, this calls the toggle function
      {
        "<leader>at",
        desc = "Enable Copilot",
      },
    },
    config = function(_, opts)
      require("copilot").setup(opts)

      -- `is_disabled` incorrectly returns false for the first one,
      -- when it should be true.
      -- To resolve that, treat the first call differently.
      local first_call = true
      Snacks.toggle({
        name = "Copilot",
        get = function()
          if first_call then
            first_call = false
            return false
          end
          return not require("copilot.client").is_disabled()
        end,
        set = function(state)
          if state then
            require("copilot.command").enable()
          else
            require("copilot.command").disable()
          end
        end,
      }):map("<leader>at")
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      table.insert(
        opts.sections.lualine_x,
        2,
        KyzVim.lualine.status(KyzVim.icons.kinds.Copilot, function()
          local clients = package.loaded["copilot"] and vim.lsp.get_clients({ name = "copilot", bufnr = 0 }) or {}
          if #clients > 0 then
            local status = require("copilot.status").data.status
            return (status == "InProgress" and "pending") or (status == "Warning" and "error") or "ok"
          end
        end)
      )
    end,
  },
}
