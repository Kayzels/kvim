vim.schedule(function()
  vim.cmd([[syntax match markdownInlineLangPrefix /`{[a-zA-Z0-9_+-]\+}\ze[^`]/ conceal]])
end)
