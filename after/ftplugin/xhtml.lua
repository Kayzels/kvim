vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt_local.formatexpr = ""
vim.opt_local.textwidth = 99999

local spec_treesitter = require("mini.ai").gen_spec.treesitter
vim.b.miniai_config = {
  custom_textobjects = {
    t = spec_treesitter({ a = "@function.outer", i = "@function.inner " }),
  },
}
