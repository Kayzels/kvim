return {
  {
    "olimorris/codecompanion.nvim",
    version = "^17",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      {
        "ravitemer/codecompanion-history.nvim",
        commit = "eb99d25",
      },
    },
    opts = {
      ---@module 'codecompanion'
      extensions = {
        history = {
          enabled = true,
          opts = {
            keymap = "gh",
            save_chat_keymap = "sc",
            auto_save = true,
            expiration_days = 0,
            picker = "snacks.nvim",
            auto_generate_title = true,
            continue_last_chat = false,
            delete_on_clearing = false,
            dir_to_save = vim.fn.stdpath("data") .. "/codecompanion_history",
            enable_logging = false,
          },
        },
      },
      adapters = {
        ---@type fun():CodeCompanion.HTTPAdapter|CodeCompanion.ACPAdapter
        gemini = function()
          return require("codecompanion.adapters").extend("gemini", {
            env = {
              api_key = 'cmd:kwallet-query -f "CodeCompanion" -r Gemini kdewallet',
            },
          })
        end,
      },
      ---@type CodeCompanion.Strategies
      ---@diagnostic disable-next-line: missing-fields
      strategies = {
        chat = {
          adapter = "gemini",
          roles = {
            ---@type string|fun(adapter: CodeCompanion.HTTPAdapter|CodeCompanion.ACPAdapter): string
            llm = function(adapter)
              return "󰚩  CodeCompanion " .. "(" .. adapter.formatted_name .. ")"
            end,
            ---@type string
            user = (function()
              local name = vim.env.USER or "Me"
              return "  " .. name:sub(1, 1):upper() .. name:sub(2)
            end)(),
          },
        },
        inline = {
          adapter = "gemini",
        },
      },
    },
    keys = {
      { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", desc = "CodeCompanion chat" },
    },
    cmd = {
      "CodeCompanion",
      "CodeCompanionChat",
      "CodeCompanionCmd",
      "CodeCompanionActions",
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      overrides = {
        filetype = {
          codecompanion = {
            render_modes = { "n", "c", "v" },
            heading = {
              -- Remove the circle showing for H2, that's the user and bot heading
              icons = { "󰲡 ", " ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
            },
          },
        },
      },
    },
  },
}
