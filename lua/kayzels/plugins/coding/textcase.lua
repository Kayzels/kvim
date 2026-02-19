---@class TextCaseMapping : TextCaseKeymapDefinition
---@field desc string

---@module 'lazy'
---Needed so that LazyKeysSpec is a known type

---@type TextCaseMapping[]
local text_case_defs = {
  { quick_replace = "u", operator = "ou", method_name = "to_upper_case", lsp_rename = "U", desc = "TO UPPER CASE" },
  { quick_replace = "l", operator = "ol", method_name = "to_lower_case", lsp_rename = "L", desc = "to lower case" },
  { quick_replace = "s", operator = "os", method_name = "to_snake_case", lsp_rename = "S", desc = "to_snake_case" },
  { quick_replace = "k", operator = "ok", method_name = "to_dash_case", lsp_rename = "K", desc = "to-kebab-case" },
  --stylua: ignore
  { quick_replace = "n", operator = "on", method_name = "to_constant_case", lsp_rename = "N", desc = "TO_CONSTANT_CASE" },
  { quick_replace = "d", operator = "od", method_name = "to_dot_case", lsp_rename = "D", desc = "to.dot.case" },
  { quick_replace = "c", operator = "oc", method_name = "to_camel_case", lsp_rename = "C", desc = "toCamelCase" },
  { quick_replace = "p", operator = "op", method_name = "to_pascal_case", lsp_rename = "P", desc = "ToPascalCase" },
  { quick_replace = "t", operator = "ot", method_name = "to_title_case", lsp_rename = "T", desc = "To Title Case" },
  { quick_replace = "/", operator = "o/", method_name = "to_path_case", lsp_rename = "?", desc = "to/path/case" },
  { quick_replace = "f", operator = "of", method_name = "to_phrase_case", lsp_rename = "F", desc = "To phrase case" },
}

---@param opts TextCaseMapping
---@return LazyKeysSpec[]
local function set_mapping(opts)
  local key = opts.quick_replace
  local operator = opts.operator
  local lsp = opts.lsp_rename
  local desc = opts.desc

  ---@type LazyKeysSpec
  local n_mode = {
    "ga" .. key,
    desc = "Convert " .. desc,
    mode = { "x", "n" },
  }
  ---@type LazyKeysSpec
  local lsp_mode = {
    "ga" .. lsp,
    desc = "LSP rename " .. desc,
  }
  ---@type LazyKeysSpec
  local op_mode = {
    "ga" .. operator,
    desc = desc,
  }
  return { n_mode, lsp_mode, op_mode }
end

---@return LazyKeysSpec[]
local function set_text_case_mappings()
  if not vim.g.vscode then
    local wk = require("which-key")
    wk.add({ "ga", group = "+text-case" })
    wk.add({ "gao", group = "Pending Mode Operator" })
  end

  ---@type LazyKeysSpec[]
  local mappings = {}
  for _, def in ipairs(text_case_defs) do
    local mapping = set_mapping(def)
    for _, v in ipairs(mapping) do
      table.insert(mappings, v)
    end
  end

  return mappings
end

return {
  {
    "Kayzels/text-case.nvim",
    dev = true,
    ---@module 'textcase'
    ---@param opts textcase.config
    config = function(_, opts)
      require("textcase").setup(opts)
      local api = require("textcase.plugin.api")
      for _, def in ipairs(text_case_defs) do
        api[def.method_name].desc = def.desc
      end
      require("textcase").setup_keymappings(text_case_defs)
    end,
    ---@type textcase.config
    opts = {
      default_keymappings_enabled = false,
    },
    keys = set_text_case_mappings,
    cmd = { "Subs" },
    vscode = true,
  },
}
