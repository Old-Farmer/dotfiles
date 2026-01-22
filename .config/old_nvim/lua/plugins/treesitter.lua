return {
  -- TODO: optimize performance for treesitter
  -- Quite slow for c++
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = { "mason-org/mason.nvim" },
    branch = "main",
    build = ":TSUpdate",
    lazy = false,
    opts = {
      ensure_installed = {
        "awk",
        "bash",
        -- "c",
        "diff",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        -- "lua",
        "luadoc",
        "luap",
        -- "markdown",
        -- "markdown_inline",
        "printf",
        "python",
        -- "query",
        "regex",
        "toml",
        "tsx",
        "typescript",
        -- "vim",
        -- "vimdoc",
        "xml",
        "yaml",
      },
    },
    config = function(_, opts)
      local nvim_treesitter = require("nvim-treesitter")
      nvim_treesitter.setup({
        -- Directory to install parsers and queries to
        install_dir = vim.fn.stdpath("data") .. "/site",
      })
      nvim_treesitter.install(opts.ensure_installed)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = opts.ensure_installed,
        callback = function()
          vim.treesitter.start()
          vim.wo.foldmethod = "expr"
          vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    branch = "main", -- Use main branch
    keys = {
      {
        "af",
        function()
          require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
        end,
        mode = { "x", "o" },
        desc = "Function(outer)",
      },
      {
        "if",
        function()
          require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
        end,
        mode = { "x", "o" },
        desc = "Function(inner)",
      },
      {
        "ac",
        function()
          require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
        end,
        mode = { "x", "o" },
        desc = "Class(outer)",
      },
      {
        "ic",
        function()
          require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
        end,
        mode = { "x", "o" },
        desc = "Class(inner)",
      },
      {
        "as",
        function()
          require("nvim-treesitter-textobjects.select").select_textobject("@local.scope", "locals")
        end,
        mode = { "x", "o" },
        desc = "Scope",
      },
      {
        "<leader>a",
        function()
          require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
        end,
        desc = "Swap parameter(inner)",
      },
      {
        "<leader>A",
        function()
          require("nvim-treesitter-textobjects.swap").swap_next("@parameter.outer")
        end,
        desc = "Swap parameter(outer)",
      },
      {
        "]m",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Next method start",
      },
      {
        "[m",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Prev method start",
      },
      {
        "]M",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Next method end",
      },
      {
        "[M",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Prev method end",
      },
      {
        "]c",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Next class start",
      },
      {
        "[c",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Prev class start",
      },
      {
        "]C",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_end("@class.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Next class end",
      },
      {
        "[C",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_end("@class.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Prev class end",
      },
      {
        "[o",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_start("@loop.*", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Next loop",
      },
      {
        "]o",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_start("@loop.*", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Prev loop",
      },
      {
        "[i",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_start("@conditional.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Next conditional",
      },
      {
        "]i",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_start("@conditional.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Prev conditional",
      },
      {
        "[s",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_start("@local.scope", "locals")
        end,
        mode = { "n", "x", "o" },
        desc = "Next scope",
      },
      {
        "]s",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_start("@local.scope", "locals")
        end,
        mode = { "n", "x", "o" },
        desc = "Prev scope",
      },
    },
    opts = {
      select = {
        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,
        -- You can choose the select mode (default is charwise 'v')
        --
        -- Can also be a function which gets passed a table with the keys
        -- * query_string: eg '@function.inner'
        -- * method: eg 'v' or 'o'
        -- and should return the mode ('v', 'V', or '<c-v>') or a table
        -- mapping query_strings to modes.
        -- selection_modes = {
        --   ["@parameter.outer"] = "v", -- charwise
        --   ["@function.outer"] = "V", -- linewise
        --   ["@class.outer"] = "<c-v>", -- blockwise
        -- },
      },
      move = {
        -- whether to set jumps in the jumplist
        set_jumps = true,
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "VeryLazy",
    opts = { max_lines = 3 },
  },
}
