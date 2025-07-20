---@class kayzels.utils.plugin
local M = {}

M.lazy_file_events = { "BufReadPost", "BufNewFile", "BufWritePre" }

function M.lazy_file()
  local Event = require("lazy.core.handler.event")
  Event.mappings.LazyFile = { id = "LazyFile", event = M.lazy_file_events }
  Event.mappings["User LazyFile"] = Event.mappings.LazyFile
end

function M.setup()
  M.lazy_file()
end

---Extend a table of plugin specs to have the specs found in the plugin subfolder
---for the specific name.
---That is, if a plugin is in kayzels.plugins.editor.extras,
---this should be called with the editor spec, the folder name "editor" and then
---"extras" in the table for names.
---@param spec table
---@param folder string
---@param names string[]
function M.extend_spec(spec, folder, names)
  ---@param name string
  local req = function(name)
    return require("kayzels.plugins." .. folder .. "." .. name)
  end

  for _, name in ipairs(names) do
    -- current_spec can be either a list of plugin specs, or a single spec
    -- if a single spec, we assume it has a string as first key
    ---@type table
    local current_spec = req(name)
    if #current_spec > 0 then
      if type(#current_spec[1]) == "table" then
        vim.list_extend(spec, current_spec)
      else
        spec[#spec + 1] = current_spec
      end
    end
  end
end

return M
