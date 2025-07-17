---@diagnostic disable: inject-field

---@alias LspMethod vim.lsp.protocol.Method.ClientToServer
---@alias LspKeySpec LazyKeysSpec|{has?:LspMethod|LspMethod[], cond?:fun():boolean}
---@alias LspKeys LazyKeys|{has?:string|string[], cond?:fun():boolean}

local M = {}

---@type LspKeySpec[]|nil
M._keys = nil

---@return LspKeySpec
function M.get()
  if M._keys then
    return M._keys
  end

  -- stylua: ignore
  M._keys = {
    { "<leader>cl", function() Snacks.picker.lsp_config() end, desc = "Lsp Info", },
    { "<leader>cL", "<cmd>checkhealth vim.lsp<cr>", desc = "Lsp Info", },
    { "gd", vim.lsp.buf.definition, desc = "Goto Definition", has = "textDocument/definition" },
    { "gI", vim.lsp.buf.implementation, desc = "Goto Implementation" },
    { "gy", vim.lsp.buf.type_definition, desc = "Goto T[y]pe Definition" },
    { "gD", vim.lsp.buf.declaration, desc = "Goto Declaraion" },
    -- K is already hover by default now
    {
      "gK",
      function()
        return vim.lsp.buf.signature_help()
      end,
      desc = "Signature Help",
      has = "textDocument/signatureHelp",
    },
    {
      "<c-k>",
      function()
        return vim.lsp.buf.signature_help()
      end,
      mode = "i",
      desc = "Signature Help",
      has = "textDocument/signatureHelp",
    },
    { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" }, has = "textDocument/codeAction" },
    { "<leader>cc", vim.lsp.codelens.run, desc = "Run Codelens", mode = { "n", "v" }, has = "textDocument/codeLens" },
    { "<leader>cC", vim.lsp.codelens.refresh, desc = "Refresh & Display Codelens", mode = { "n" }, has = "textDocument/codeLens" },
    {
      "<leader>cR",
      function()
        Snacks.rename.rename_file()
      end,
      desc = "Rename File",
      mode = { "n" },
      has = { "workspace/didRenameFiles", "workspace/willRenameFiles" },
    },
    -- { "<leader>cr", vim.lsp.buf.rename, desc = "Rename", has = "rename" },
    {
      "<leader>cr",
      function()
        local inc_rename = require("inc_rename")
        return ":" .. inc_rename.config.cmd_name .. " " .. vim.fn.expand("<cword>")
      end,
      expr = true,
      desc = "Rename (inc-rename)",
      has = "textDocument/rename",
    },
    { "<leader>cA", require("kayzels.lsp.util").action.source, desc = "Source Action", has = "textDocument/codeAction" },
    { "]]", function() Snacks.words.jump(vim.v.count1) end, has = "textDocument/documentHighlight",
      desc = "Next Reference", cond = function() return Snacks.words.is_enabled() end, },
    { "[[", function() Snacks.words.jump(-vim.v.count1) end, has = "textDocument/documentHighlight",
      desc = "Prev Reference", cond = function() return Snacks.words.is_enabled() end, },
    { "<a-n>", function() Snacks.words.jump(vim.v.count1, true) end, has = "textDocument/documentHighlight",
      desc = "Next Reference", cond = function() return Snacks.words.is_enabled() end, },
    { "<a-p>", function() Snacks.words.jump(-vim.v.count1, true) end, has = "textDocument/documentHighlight",
      desc = "Prev Reference", cond = function() return Snacks.words.is_enabled() end, },
    { "<leader>ss", function () Snacks.picker.lsp_symbols({ filter = require("kayzels.utils.filter").kind_filter }) end, desc = "LSP Symbols", has = "textDocument/documentSymbol" },
    { "<leader>sS", function () Snacks.picker.lsp_workspace_symbols({ filter = require("kayzels.utils.filter").kind_filter }) end, desc = "LSP Workspace Symbols", has = "workspace/symbol" }
  }

  return M._keys
end

---Returns whether any of the clients attached to a buffer support a specific LSP method
---@param buffer number
---@param method LspMethod|LspMethod[]
function M.has(buffer, method)
  if type(method) == "table" then
    for _, m in ipairs(method) do
      if M.has(buffer, m) then
        return true
      end
    end
    return false
  end
  local clients = vim.lsp.get_clients({ bufnr = buffer })
  for _, client in ipairs(clients) do
    if client:supports_method(method, buffer) then
      return true
    end
  end
  return false
end

---@type table<string, LspKeySpec[]>
M.server_keys = {
  ruff = {
    {
      "<leader>co",
      require("kayzels.lsp.util").action["source.organizeImports"],
      desc = "Organize Imports",
    },
  },
}

---Adds server specific keys to the keymaps that should be added to a buffer
---@param buffer number
---@return LspKeys[]
function M.resolve(buffer)
  local Keys = require("lazy.core.handler.keys")
  if not Keys.resolve then
    return {}
  end
  local spec = vim.tbl_extend("force", {}, M.get())

  local clients = vim.lsp.get_clients({ bufnr = buffer })
  for _, client in ipairs(clients) do
    local maps = M.server_keys[client.name] or {}
    vim.list_extend(spec, maps)
  end

  return Keys.resolve(spec)
end

---@param buffer number
function M.on_attach(_, buffer)
  local Keys = require("lazy.core.handler.keys")
  local keymaps = M.resolve(buffer)

  for _, keys in pairs(keymaps) do
    local has = not keys.has or M.has(buffer, keys.has)
    local cond = not (keys.cond == false or ((type(keys.cond) == "function") and not keys.cond()))

    if has and cond then
      local opts = Keys.opts(keys)
      opts.cond = nil
      opts.has = nil
      opts.silent = opts.silent ~= false
      opts.buffer = buffer
      vim.keymap.set(keys.mode or "n", keys.lhs, keys.rhs, opts)
    end
  end
end

return M
