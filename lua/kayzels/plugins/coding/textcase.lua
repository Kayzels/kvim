---@class TextCaseMapping
---@field key string
---@field case string
---@field lsp string
---@field desc string

---@module 'lazy'
---Needed so that LazyKeysSpec is a known type

---@return TextCaseKeymapDefinition[]
local function extend_keymap_definitions()
  local definitions = require("textcase").default_keymapping_definitions

  vim.list_extend(definitions, {
    { method_name = "to_title_case", quick_replace = "t", operator = "ot", lsp_rename = "T" },
    { method_name = "to_path_case", quick_replace = "/", operator = "o/", lsp_rename = "?" },
    { method_name = "to_phrase_case", quick_replace = "f", operator = "of", lsp_rename = "F" },
    { method_name = "to_dot_case", quick_replace = "d", operator = "od", lsp_rename = "D" },
  })

  for i, def in ipairs(definitions) do
    if def.method_name == "to_dash_case" then
      definitions[i] = vim.tbl_extend("force", def, { quick_replace = "k", lsp_rename = "K", operator = "ok" })
    end
  end

  return definitions
end

---@param opts TextCaseMapping
---@return LazyKeysSpec[]
local function set_mapping(opts)
  local key = opts.key
  local lsp = opts.lsp
  local desc = opts.desc

  ---@type LazyKeysSpec
  local n_mode = {
    "ga" .. key,
    desc = "Convert " .. desc,
  }
  ---@type LazyKeysSpec
  local lsp_mode = {
    "ga" .. lsp,
    desc = "LSP rename " .. desc,
  }
  ---@type LazyKeysSpec
  local op_mode = {
    "gao" .. key,
    desc = desc,
  }
  ---@type LazyKeysSpec
  local x_mode = {
    "ga" .. key,
    desc = "Convert " .. desc,
    mode = { "x" },
  }
  return { n_mode, lsp_mode, op_mode, x_mode }
end

---@return LazyKeysSpec[]
local function set_text_case_mappings()
  if not vim.g.vscode then
    local wk = require("which-key")
    wk.add({ "ga", group = "Text Case" })
    wk.add({ "gao", group = "Pending Mode Operator" })
  end
  ---@type TextCaseMapping[]
  local defs = {
    { key = "u", case = "to_upper_case", lsp = "U", desc = "TO UPPER CASE" },
    { key = "l", case = "to_lower_case", lsp = "L", desc = "to lower case" },
    { key = "s", case = "to_snake_case", lsp = "S", desc = "to_snake_case" },
    { key = "k", case = "to_dash_case", lsp = "K", desc = "to-kebab-case" },
    { key = "n", case = "to_constant_case", lsp = "N", desc = "TO_CONSTANT_CASE" },
    { key = "d", case = "to_dot_case", lsp = "D", desc = "to.dot.case" },
    { key = "c", case = "to_camel_case", lsp = "C", desc = "toCamelCase" },
    { key = "p", case = "to_pascal_case", lsp = "P", desc = "ToPascalCase" },
    { key = "t", case = "to_title_case", lsp = "T", desc = "To Title Case" },
    { key = "/", case = "to_path_case", lsp = "?", desc = "to/path/case" },
    { key = "f", case = "to_phrase_case", lsp = "F", desc = "To phrase case" },
  }

  ---@type LazyKeysSpec[]
  local mappings = {}
  for _, def in ipairs(defs) do
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
      require("textcase.plugin.api").to_dash_case.desc = "to-kebab-case"
      local defs = extend_keymap_definitions()
      require("textcase").setup_keymappings(defs)
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
