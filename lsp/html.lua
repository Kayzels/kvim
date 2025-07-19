return {
  cmd = { "vscode-html-language-server", "--stdio" },
  filetypes = {
    "html",
    "xhtml",
  },
  root_markers = { "package.json", ".git" },
  init_options = {
    provideFormatter = true,
    embeddedLanguages = { css = true, javascript = true },
    configurationSection = { "html", "css", "javascript" },
  },
  settings = {
    html = {
      format = {
        wrapLineLength = 0,
        indentInnerHtml = false,
        maxPreserveNewLines = 2,
      },
    },
  },
}
