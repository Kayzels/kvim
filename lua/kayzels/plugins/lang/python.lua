return {
  {
    "mfussenegger/nvim-dap-python",
    keys = {
      {
        "<leader>dPt",
        function()
          require("dap-python").test_method()
        end,
        desc = "Debug Method",
        ft = "python",
      },
      {
        "<leader>dPc",
        function()
          require("dap-python").test_class()
        end,
        desc = "Debug Class",
        ft = "python",
      },
    },
    -- NOTE: Not sure if this is needed. Has issues if venv automatically selected.
    config = function()
      -- require("dap-python").setup(KyzVim.get_pkg_path("debugpy", "/venv/bin/python"))
      require("dap-python").setup("debugpy-adapter")
    end,
  },
  {
    -- "linux-cultist/venv-selector.nvim",
    -- NOTE: Using this PR for Snacks.picker until mereged
    "tonycsoka/venv-selector.nvim",
    dependencies = {
      "mfussenegger/nvim-dap",
      "mfussenegger/nvim-dap-python",
    },
    branch = "regexp",
    cmd = "VenvSelect",
    ---@module 'venv-selector'
    ---@type venv-selector.Config
    opts = {
      ---@diagnostic disable-next-line: missing-fields
      options = {
        notify_user_on_venv_activation = false,
      },
    },
    ft = "python",
    keys = {
      { "<leader>cv", "<cmd>:VenvSelect<cr>", desc = "Select VirtualEnv", ft = "python" },
    },
  },
}
