local M = {}

local names = { "json", "markdown", "python", "sql" }
KyzVim.plugin.extend_spec(M, "extras.lang", names)

return M
