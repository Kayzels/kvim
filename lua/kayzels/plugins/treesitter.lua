return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    version = false,
    build = function()
      local TS = require("nvim-treesitter")
      KyzVim.treesitter.ensure_treesitter_cli(function()
        TS.update(nil, { summary = true })
      end)
    end,
    event = { "LazyFile", "VeryLazy" },
    lazy = vim.fn.argc(-1) == 0, -- Load treesitter early when opening a file from the cmdline
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    opts_extend = { "ensure_installed" },
    ---@alias kyzvim.TSFeat { enable?: boolean, disable?: string[] }
    ---@class kyzvim.TSConfig: TSConfig
    opts = {
      highlight = { enable = true }, ---@type kyzvim.TSFeat
      indent = { enable = true }, ---@type kyzvim.TSFeat
      folds = { enable = true }, ---@type kyzvim.TSFeat
      ensure_installed = {
        "bash",
        "c",
        "css",
        "diff",
        "git_config",
        "gitcommit",
        "git_rebase",
        "gitignore",
        "gitattributes",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "json5",
        "latex",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "ninja",
        "printf",
        "python",
        "query",
        "regex",
        "rst",
        "scss",
        "svelte",
        "tcss",
        "toml",
        "tsx",
        "typescript",
        "typst",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
      },
    },
    ---@param opts kyzvim.TSConfig
    config = function(_, opts)
      local TS = require("nvim-treesitter")
      TS.setup(opts)
      KyzVim.treesitter.get_installed(true) -- intialize the installed langs

      local install = vim.tbl_filter(function(lang)
        return not KyzVim.treesitter.have(lang)
      end, opts.ensure_installed or {})
      if #install > 0 then
        KyzVim.treesitter.ensure_treesitter_cli(function()
          TS.install(install, { summary = true }):await(function()
            KyzVim.treesitter.get_installed(true)
          end)
        end)
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("kyzvim_treesitter", { clear = true }),
        callback = function(ev)
          local ft, lang = ev.match, vim.treesitter.language.get_lang(ev.match)
          if not KyzVim.treesitter.have(ft) then
            return
          end

          ---@param feat string
          ---@param query string
          local function enabled(feat, query)
            local f = opts[feat] or {} ---@type kyzvim.TSFeat
            return f.enable ~= false
              and not (type(f.disable) == "table" and vim.tbl_contains(f.disable, lang))
              and KyzVim.treesitter.have(ft, query)
          end

          -- highlighting
          if enabled("highlight", "highlights") then
            pcall(vim.treesitter.start, ev.buf)
          end

          -- indents
          if enabled("indent", "indents") then
            KyzVim.set_default("indentexpr", "v:lua.KyzVim.treesitter.indentexpr()")
          end

          -- folds
          if enabled("folds", "folds") then
            if KyzVim.set_default("foldmethod", "expr") then
              KyzVim.set_default("foldexpr", "v:lua.KyzVim.treesitter.foldexpr()")
            end
          end
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "TSUpdate",
        callback = function()
          require("nvim-treesitter.parsers").tcss = {
            install_info = {
              url = "https://github.com/Kayzels/tree-sitter-tcss",
              branch = "main",
              queries = "queries",
            },
            tier = 2,
          }
        end,
      })

      vim.filetype.add({
        extension = {
          tcss = "tcss",
        },
      })

      vim.treesitter.language.register("html", { "xhtml" })
      vim.treesitter.language.register("markdown", { "tabs" })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = "VeryLazy",
    branch = "main",
    opts = {},
    keys = function()
      local moves = {
        goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
        goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
        goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
        goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
      }
      local ret = {} ---@type LazyKeysSpec[]
      for method, keymaps in pairs(moves) do
        for key, query in pairs(keymaps) do
          local desc = query:gsub("@", ""):gsub("%..*", "")
          desc = desc:sub(1, 1):upper() .. desc:sub(2)
          desc = (key:sub(1, 1) == "[" and "Prev " or "Next ") .. desc
          desc = desc .. (key:sub(2, 2) == key:sub(2, 2):upper() and " End" or " Start")
          ret[#ret + 1] = {
            key,
            function()
              -- don't use treesitter if in diff mode and the key is one of the c/C keys
              if vim.wo.diff and key:find("[cC]") then
                return vim.cmd("normal! " .. key)
              end
              require("nvim-treesitter-textobjects.move")[method](query, "textobjects")
            end,
            desc = desc,
            mode = { "n", "x", "o" },
            silent = true,
          }
        end
      end
      return ret
    end,
    config = function(_, opts)
      local TS = require("nvim-treesitter-textobjects")
      TS.setup(opts)
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    event = "LazyFile",
    opts = {},
  },
}
