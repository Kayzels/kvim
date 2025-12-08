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
    ---@class kyzvim.TSConfig: TSConfig
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      folds = { enable = true },
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
        "jsonc",
        "latex",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "norg",
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
          if not KyzVim.treesitter.have(ev.match) then
            return
          end

          -- highlighting
          if vim.tbl_get(opts, "highlight", "enable") ~= false then
            pcall(vim.treesitter.start)
          end

          -- indents
          if vim.tbl_get(opts, "indent", "enable") ~= false then
            KyzVim.set_default("indentexpr", "v:lua.KyzVim.treesitter.indentexpr()")
          end

          -- folds
          if vim.tbl_get(opts, "folds", "enable") ~= false then
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
