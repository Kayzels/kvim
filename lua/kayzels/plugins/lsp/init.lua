return {
  {
    "neovim/nvim-lspconfig",
    enabled = false,
    event = "LazyFile",
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
    },
  },
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    opts = {},
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
  },
}
