---@class TextCaseMapping
---@field key string
---@field case string
---@field lsp string
---@field desc string

---@param opts TextCaseMapping
---@return LazyKeysSpec[]
local function set_mapping(opts)
  local key = opts.key
  local case = opts.case
  local lsp = opts.lsp
  local desc = opts.desc
  local textcase = require("textcase")

  ---@type LazyKeysSpec
  local n_mode = {
    "ga" .. key,
    function()
      textcase.current_word(case)
    end,
    desc = "Convert " .. desc,
  }
  ---@type LazyKeysSpec
  local lsp_mode = {
    "ga" .. lsp,
    function()
      textcase.lsp_rename(case)
    end,
    desc = "LSP rename " .. desc,
  }
  ---@type LazyKeysSpec
  local op_mode = {
    "gao" .. key,
    function()
      textcase.operator(case)
    end,
    desc = desc,
  }
  ---@type LazyKeysSpec
  local x_mode = {
    "ga" .. key,
    function()
      textcase.operator(case)
    end,
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
    "johmsalas/text-case.nvim",
    config = function(_, opts)
      require("textcase").setup(opts)
    end,
    opts = {
      default_keymappings_enabled = false,
    },
    keys = set_text_case_mappings,
    cmd = { "Subs" },
    vscode = true,
  },
}
