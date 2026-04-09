--- Remove the semantic tokens for delta, as this seems to be
--- breaking the highlighting when lines are deleted or rearranged.
--- It might be caused by the range one, but I don't think so.
--- But leaving that part commented out in case.
---@param client vim.lsp.Client
---@param _ integer
local on_attach = function(client, _)
  if client.server_capabilities.semanticTokensProvider then
    if client.server_capabilities.semanticTokensProvider.full then
      client.server_capabilities.semanticTokensProvider.full.delta = false
    end

    -- client.server_capabilities.semanticTokensProvider.range = false
  end
end

return {
  cmd = { "qmlls6" },
  filetypes = { "qml", "qmljs" },
  root_markers = { ".git", ".qmlls.ini" },
  on_attach = on_attach,
}
