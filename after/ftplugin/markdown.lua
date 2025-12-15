vim.schedule(function()
  vim.cmd([[syntax match markdownInlineLangPrefix /`{[a-zA-Z0-9_+-]\+}\ze[^`]/ conceal]])
end)

-- Needed so that blockquotes don't get cutoff text but keep their leading part.
-- Has a side effect that normal paragraphs have a hanging indent
-- Note that these are *window*-specific, so use vim.opt_local instead of vim.bo
vim.opt_local.showbreak = "  "
vim.opt_local.breakindent = true
vim.opt_local.breakindentopt = ""
