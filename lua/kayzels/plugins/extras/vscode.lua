if not vim.g.vscode then
  return {}
end

local vscode = require("vscode")

-- Enable certain plugins
local enabled = {
  "dial.nvim",
  "lazy.nvim",
  "mini.ai",
  "mini.move",
  "mini.pairs",
  "mini.surround",
  "nvim-treesitter",
  "nvim-treesitter-textobjects",
  "nvim-ts-context-commentstring",
  "snacks.nvim",
  "ts-comments.nvim",
  "yanky.nvim",
}

local Config = require("lazy.core.config")
Config.options.checker.enabled = false
Config.options.change_detection.enabled = false
Config.options.defaults.cond = function(plugin)
  ---@diagnostic disable-next-line: undefined-field
  return vim.tbl_contains(enabled, plugin.name) or plugin.vscode
end
vim.g.snacks_animate = false

-- VScode specific keymaps
vim.api.nvim_create_autocmd("User", {
  pattern = "VSCodeVimKeymaps",
  callback = function()
    -- VSCode-specific keymaps for search and navigation
    vim.keymap.set("n", "<leader><space>", "<cmd>Find<cr>")
    vim.keymap.set("n", "<leader>/", function()
      vscode.call("workbench.action.findInFiles")
    end)
    vim.keymap.set("n", "<leader>ss", function()
      vscode.call("workbench.action.gotoSymbol")
    end)

    -- Toggle VSCode integrated terminal
    for _, lhs in ipairs({ "<leader>ft", "<leader>fT", "<c-/>" }) do
      vim.keymap.set("n", lhs, function()
        vscode.call("workbench.action.terminal.toggleTerminal")
      end)
    end

    -- Navigate VSCode tabs like Neovim buffers
    vim.keymap.set("n", "<S-h>", function()
      vscode.call("workbench.action.previousEditor")
    end)
    vim.keymap.set("n", "<S-l>", function()
      vscode.call("workbench.action.nextEditor")
    end)
  end,
})

return {
  {
    "snacks.nvim",
    ---@module 'snacks'
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = false },
      dashboard = { enabled = false },
      indent = { enabled = false },
      input = { enabled = false },
      notifier = { enabled = false },
      picker = { enabled = false },
      quickfile = { enabled = false },
      scroll = { enabled = false },
      statuscolumn = { enabled = false },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      highlight = {
        enable = false,
      },
    },
  },
}
