-- FIXME: Currently creating a new instance of LSP and formatter per buffer,
-- rather than using existing. Means workspace is always reloading.

local M = {}

local LspFormat = require("kayzels.lsp.format")
local LspKeys = require("kayzels.lsp.keys")
local LspUtils = require("kayzels.lsp.util")

function M._setup_diagnostics()
  local icons = KyzVim.icons.diagnostics
  vim.diagnostic.config({
    underline = true,
    virtual_text = {
      spacing = 4,
      source = "if_many",
      prefix = function(diagnostic)
        for d, icon in pairs(icons) do
          if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
            return icon --[[@as string]]
          end
        end
        return "●"
      end,
    },
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = icons.Error,
        [vim.diagnostic.severity.WARN] = icons.Warn,
        [vim.diagnostic.severity.HINT] = icons.Hint,
        [vim.diagnostic.severity.INFO] = icons.Info,
      },
    },
    float = {
      border = "rounded",
      source = true,
    },
    update_in_insert = false,
    severity_sort = true,
  })
end

--- Add capabilities for blink and custom ones to the default LSP capabilities
function M._make_capabilities()
  local custom_capabilities = {
    workspace = {
      fileOperations = {
        didRename = true,
        willRename = true,
      },
    },
  }
  local capabilities = vim.tbl_deep_extend(
    "force",
    {},
    vim.lsp.protocol.make_client_capabilities(),
    not vim.g.vscode and require("blink.cmp").get_lsp_capabilities() or {},
    custom_capabilities
  )

  vim.lsp.config("*", {
    capabilities = capabilities,
  })
end

function M._enable_servers()
  local server_configs = vim
    .iter(vim.api.nvim_get_runtime_file("lsp/*.lua", true))
    :map(function(file)
      return vim.fn.fnamemodify(file, ":t:r")
    end)
    :totable()

  -- Call explicitly before enabling configs, to get commands
  if not vim.g.vscode then
    require("mason").setup()
  end
  vim.lsp.enable(server_configs)
end

function M._attach_keys()
  LspUtils.on_attach(function(client, buffer)
    LspKeys.on_attach(client, buffer)
  end)
end

--- Display inlay hints automatically if a server supports them
function M._inlay_hints()
  LspUtils.on_supports_method("textDocument/inlayHint", function(_, buffer)
    if vim.api.nvim_buf_is_valid(buffer) and vim.bo[buffer].buftype == "" then
      vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
    end
  end)
end

--- Display codelens if supported by the server
function M._codelens()
  if vim.lsp.codelens then
    LspUtils.on_supports_method("textDocument/codeLens", function(_, buffer)
      vim.lsp.codelens.refresh()
      vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
        buffer = buffer,
        callback = vim.lsp.codelens.refresh,
      })
    end)
  end
end

--- Use treesitter for folding if LSP folding isn't supported
function M._setup_folds()
  vim.o.foldmethod = "expr"
  vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
  LspUtils.on_supports_method("textDocument/foldingRange", function(_, _)
    local win = vim.api.nvim_get_current_win()
    -- foldexpr is window local, not buffer local
    vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
  end)
end

--- Custom changes that should be made after on_attach for specific servers
function M._modify_servers()
  LspUtils.on_attach(function(client, _)
    if client.name == "ruff" then
      client.server_capabilities.hoverProvider = false
    end
  end, "ruff")
end

local did_setup = false

---@return boolean
function M.state()
  return did_setup
end

function M.setup()
  if did_setup then
    return
  end
  did_setup = true

  M._setup_diagnostics()
  M._make_capabilities()

  -- setup autoformat
  KyzVim.format.register(LspFormat.formatter())

  M._attach_keys()
  M._inlay_hints()
  M._setup_folds()
  -- M._codelens()
  M._modify_servers()
  M._enable_servers()

  LspUtils.setup()
  LspUtils.on_dynamic_capability(LspKeys.on_attach)

  vim.lsp.buf.definition = Snacks.picker.lsp_definitions
  vim.lsp.buf.references = Snacks.picker.lsp_references
  vim.lsp.buf.implementation = Snacks.picker.lsp_implementations
  vim.lsp.buf.type_definition = Snacks.picker.lsp_type_definitions

  -- Add mappings to which-key for defaults
  if not vim.g.vscode then
    local wk = require("which-key")
    wk.add({
      { "gr", group = "LSP Go To" },
      { "gra", desc = "Code actions" },
      { "gri", desc = "Go to Implementation" },
      { "grn", desc = "Rename" },
      { "grr", desc = "References" },
      { "grt", desc = "Go to Type Definition" },
    })
  end
end

return M
