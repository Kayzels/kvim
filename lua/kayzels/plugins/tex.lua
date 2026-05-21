---@alias FileInfo {jobname: string, root: string, target: string, target_basename: string, target_name: string }

---Create tex output directory
---@param file_info FileInfo
---@return string
local function GetOutputDir(file_info)
  local root_patterns = { "Notes", "Exercises", "Assignment", "Assessment", "Exam", "cv", "Motivational" }
  local result = ""
  for _, pattern in ipairs(root_patterns) do
    if string.find(string.lower(file_info.jobname), string.lower(pattern), 1) ~= nil then
      result = "./out"
      break
    else
      local subdir_root = file_info.root
      ---@diagnostic disable-next-line: cast-local-type
      subdir_root = vim.fn.fnamemodify(subdir_root, ":t")
      result = "../out/" .. subdir_root
    end
  end
  return result
end

return {
  {
    "lervag/vimtex",
    lazy = false,
    init = function()
      vim.g.vimtex_compiler_latexmk = {
        callback = 1,
        continuous = 0,
        executable = "latexmk",
        out_dir = GetOutputDir,
        options = {
          "-verbose",
          "-file-line-error",
          "-synctex=1",
          "-shell-escape",
          "-interaction=nonstopmode",
        },
      }
      vim.g.vimtex_quickfix_ignore_filters = {
        "Overfull",
        "Underfull",
        "You have requested",
        "dynindent",
      }
      vim.g.vimtex_syntax_custom_cmds = {
        {
          name = "concept",
          conceal = true,
          opt = false,
          argstyle = "bold",
        },
        {
          name = "Diamond",
          mathmode = true,
          concealchar = "◇",
          opt = false,
        },
      }
      vim.g.vimtex_indent_lists = {
        "itemize",
        "description",
        "enumerate",
        "thebibliography",
        "descriptimize",
        "descriptenum",
      }
      -- Change to Okular, still supports some Vim keys, but nicer UI
      vim.g.vimtex_view_general_viewer = "okular"
      vim.g.vimtex_view_general_options = "--unique file:@pdf\\#src:@line@tex"
      vim.g.vimtex_doc_handlers = { "vimtex#doc#handlers#texdoc" }
    end,
  },
}
