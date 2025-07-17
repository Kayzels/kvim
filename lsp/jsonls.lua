return {
  on_new_config = function(new_config)
    new_config.settings.json.schemas = new_config.settings.json.schemas or {}
    local storeschemas = require("schemastore").json.schemas()
    vim.list_extend(new_config.settings.json.schemas, storeschemas)
  end,
  settings = {
    json = {
      format = {
        enable = true,
      },
      validate = { enable = true },
    },
  },
}
