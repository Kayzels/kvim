return {
  -- No longer using lspconfig, just have the lsp folder
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    opts = {},
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
  },
}
