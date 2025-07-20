vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt

opt.autowrite = true
opt.breakindent = true

-- TODO: Check if there might be better choices for this (like popup)
opt.completeopt = "menu,menuone,noselect"

opt.conceallevel = 2
opt.confirm = true
opt.cursorline = true
opt.expandtab = true

opt.fillchars = {
  foldopen = "",
  foldclose = "",
  foldsep = " ",
  fold = " ",
  eob = " ",
}
opt.foldlevel = 99

opt.foldmethod = "expr"
opt.foldtext = ""

opt.formatexpr = "v:lua.require'kayzels.utils.format'.formatexpr()"

-- NOTE:To remove unwanted comment at start,
-- use i_CTRL-U (removes preceding chars in line)
opt.formatoptions = "jcroqlnt" -- Default is tcqj

opt.grepprg = "rg --vimgrep"

-- NOTE: Setting with autocmd instead, don't want this written down twice
-- opt.guicursor
opt.ignorecase = true
opt.inccommand = "nosplit" -- preview incremental substitute
opt.jumpoptions = "view"
opt.laststatus = 3 -- global statusline
opt.linebreak = true -- wrap long lines at convenient points
opt.list = true -- Show invisible characters (tabs, trailing spaces)
opt.listchars = {
  tab = "-->",
  trail = "•",
  nbsp = "␣",
  extends = "",
  precedes = "",
}
opt.mouse = "a"
opt.nrformats = "bin,hex,blank"
opt.number = true
opt.pumheight = 10
opt.relativenumber = true

-- NOTE: Not sure if this is just for : commands. Very irritating in VSCode,
-- so changing to see if it has an effect.
opt.report = 4 -- Reports number of lines changed. Default is 2, which is too low.
opt.ruler = false
opt.scrolloff = 6 -- My change to LazyVim has 10, LazyVim default is 4
opt.sessionoptions = {
  "buffers",
  "curdir",
  "folds",
  "globals",
  "help",
  "skiprtp",
  "tabpages",
  "winsize",
}
opt.shell = "fish"
opt.shiftround = true -- Round indent
opt.shiftwidth = 2 -- Size of an indent
opt.shortmess:append({
  W = true, -- Don't give "written" or "[w]" when writing a file
  -- I = true, -- Don't give intro messages when starting
  c = true, -- Don't give completion messages
  C = true, -- Don't give messages while scanning for completion items
})
opt.showmode = false -- Not needed, if using a statusline
opt.showtabline = 2 -- always show tabline
opt.sidescrolloff = 5 -- Columns to keep to the right of the cursor (LazyVim has 8)
opt.signcolumn = "yes"
opt.smartcase = true
opt.smartindent = true
opt.splitbelow = true -- Put new window below current, rather than above
opt.splitkeep = "screen"
opt.splitright = true -- Put new window to the right of current, rather than left

opt.tabstop = 2 -- Number of spaces tabs count for
opt.termguicolors = true
opt.tildeop = true -- Use tilde as operator instead of just per character
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.virtualedit = "block"

-- TODO: See if there's a way we can make enter on a popup item not accept
opt.wildmode = "longest:full,full" -- Command-line completion mode

opt.winborder = "rounded"
opt.winminwidth = 10
opt.wrap = false

-- Disable perl and ruby providers (neater checkhealth)
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Disable LSPs being used for roots
vim.g.root_lsp_ignore = { "copilot" }

-- Enable autoformatting
vim.g.autoformat = true

-- Show the current document symbol from Trouble in lualine
-- Can be disabled for a buffer by setting `vim.b.trouble_lualine = false`
vim.g.trouble_lualine = true
