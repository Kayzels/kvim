local M = {}

---@param direction "increment" | "decrement"
---@param g? boolean
function M.dial(direction, g)
  local action_mode = "normal"

  local mode = vim.fn.mode(true)
  local is_visual = mode == "v" or mode == "V" or mode == "\22"
  if is_visual then
    action_mode = "visual"
  end
  if g then
    action_mode = "g" .. action_mode
  end
  local group = vim.g.dials_by_ft[vim.bo.filetype] or "default"
  return require("dial.map").manipulate(direction, action_mode, group)
end

return {
  "monaqa/dial.nvim",
  vscode = true,
  keys = {
    {
      "<C-a>",
      function()
        return M.dial("increment")
      end,
      desc = "Increment",
      mode = { "n", "v" },
    },
    {
      "<C-x>",
      function()
        return M.dial("decrement")
      end,
      desc = "Decrement",
      mode = { "n", "v" },
    },
    {
      "g<C-a>",
      function()
        return M.dial("increment", true)
      end,
      desc = "Increment",
      mode = { "n", "v" },
      remap = true,
    },
    {
      "g<C-x>",
      function()
        return M.dial("decrement", true)
      end,
      desc = "Decrement",
      mode = { "n", "v" },
      remap = true,
    },
  },
  opts = function()
    local augend = require("dial.augend")

    local logical_alias = augend.constant.new({
      elements = { "&&", "||" },
      word = false,
      cyclic = true,
    })

    local logical_word = augend.constant.new({
      elements = { "and", "or" },
      word = true,
      cyclic = true,
    })

    local ordinal_numbers = augend.constant.new({
      -- elements through which we cycle. When we increment, we go down
      -- On decrement we go up
      elements = {
        "first",
        "second",
        "third",
        "fourth",
        "fifth",
        "sixth",
        "seventh",
        "eighth",
        "ninth",
        "tenth",
      },
      -- if true, it only matches strings with word boundary. firstDate wouldn't work for example
      word = false,
      -- do we cycle back and forth (tenth to first on increment, first to tenth on decrement).
      -- Otherwise nothing will happen when there are no further values
      cyclic = true,
    })

    local weekdays = augend.constant.new({
      elements = {
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday",
        "Sunday",
      },
      word = true,
      cyclic = true,
    })

    local months = augend.constant.new({
      elements = {
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December",
      },
      word = true,
      cyclic = true,
    })

    local capitalized_boolean = augend.constant.new({
      elements = {
        "True",
        "False",
      },
      word = true,
      cyclic = true,
    })

    return {
      dials_by_ft = {
        css = "css",
        sass = "css",
        scss = "css",
        javascript = "typescript",
        javascriptreact = "typescript",
        typescript = "typescript",
        typescriptreact = "typescript",
        json = "json",
        lua = "lua",
        markdown = "markdown",
        python = "python",
      },
      groups = {
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias["%Y/%m/%d"],
          augend.constant.alias.bool,
          weekdays,
          months,
          ordinal_numbers,
          capitalized_boolean,
          logical_alias,
        },
        typescript = {
          augend.constant.new({ elements = { "let", "const" } }),
        },
        css = {
          augend.hexcolor.new({
            case = "lower",
          }),
          augend.hexcolor.new({
            case = "upper",
          }),
        },
        markdown = {
          augend.constant.new({
            elements = { "[ ]", "[x]" },
            word = false,
            cyclic = true,
          }),
          augend.misc.alias.markdown_header,
        },
        json = {
          augend.semver.alias.semver,
        },
        lua = {
          logical_word,
        },
        python = {
          logical_word,
        },
      },
    }
  end,
  config = function(_, opts)
    -- copy defaults to each group
    for name, group in pairs(opts.groups) do
      if name ~= "default" then
        vim.list_extend(group, opts.groups.default)
      end
    end
    require("dial.config").augends:register_group(opts.groups)
    vim.g.dials_by_ft = opts.dials_by_ft
    -- require("dial.config").augends:on_filetype(opts.dials_by_ft)
  end,
}
