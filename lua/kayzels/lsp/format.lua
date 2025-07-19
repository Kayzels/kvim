local M = {}

M.format_options = {
  formatting_options = nil,
  timeout_ms = nil,
}

---@class LspFilter: vim.lsp.get_clients.Filter
---@field filter? fun(client: vim.lsp.Client):boolean

---@param opts? Formatter | {filter?: (string|LspFilter)}
---@return Formatter
function M.formatter(opts)
  opts = opts or {}
  local filter = opts.filter or {}
  filter = type(filter) == "string" and { name = filter } or filter
  ---@cast filter LspFilter
  ---@type Formatter
  local ret = {
    name = "LSP",
    primary = true,
    priority = 1,
    format = function(buf)
      M.format(require("lazy.core.util").merge({}, filter, { bufnr = buf }))
    end,
    sources = function(buf)
      local clients = vim.lsp.get_clients(require("lazy.core.util").merge({}, filter, { bufnr = buf }))
      ---@param client vim.lsp.Client
      local ret = vim.tbl_filter(function(client)
        return client:supports_method("textDocument/formatting")
          or client:supports_method("textDocument/rangeFormatting")
      end, clients)
      ---@param client vim.lsp.Client
      return vim.tbl_map(function(client)
        return client.name
      end, ret)
    end,
  }
  return require("lazy.core.util").merge(ret, opts) --[[@as Formatter]]
end

---@alias LspFormat{ timeout_ms?: number, format_options?:table} | LspFilter

---@param opts? LspFormat
function M.format(opts)
  opts = vim.tbl_deep_extend("force", {}, opts or {}, M.format_options or {}, KyzVim.opts("conform.nvim").format or {})

  local ok, conform = pcall(require, "conform")

  -- use conform for formatting with LSP when available,
  -- since it has better format diffing
  if ok then
    opts.formatters = {}
    conform.format(opts)
  else
    vim.lsp.buf.format(opts)
  end
end

return M
