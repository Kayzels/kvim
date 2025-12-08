---@param path string
local function set_python_path(path)
  local clients = vim.lsp.get_clients({
    bufnr = vim.api.nvim_get_current_buf(),
    name = "basedpyright",
  })
  for _, client in ipairs(clients) do
    if client.settings then
      ---@diagnostic disable-next-line: param-type-mismatch
      client.settings.python = vim.tbl_deep_extend("force", client.settings.python or {}, { pythonPath = path })
    else
      client.config.settings = vim.tbl_deep_extend("force", client.config.settings, { python = { pythonPath = path } })
    end
    ---@diagnostic disable-next-line: param-type-mismatch
    client.notify("workspace/didChangeConfiguration", { settings = nil })
  end
end

return {
  cmd = { "basedpyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    "pyrightconfig.json",
    ".git",
  },
  settings = {
    basedpyright = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
        diagnosticSeverityOverrides = {
          reportMissingSuperCall = "none",
          reportPrivateUsage = "none",
          reportUnusedCallResult = "none",
          reportAny = "none",
          reportExplicitAny = "none",
          reportUninitializedInstanceVariable = "none",
          reportUnusedVariable = "none",
        },
      },
    },
  },
  ---@param bufnr number
  on_attach = function(_, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, "LspPyrightSetPythonPath", set_python_path, {
      desc = "Reconfigure basedpyright with the provided python path",
      nargs = 1,
      complete = "file",
    })
  end,
}
