if vim.g.vscode then
  -- options
  vim.g.mapleader = " "      -- Make sure to set `mapleader` before lazy so your mappings are correct
  vim.g.maplocalleader = " " -- Same for `maplocalleader`
  vim.opt.clipboard = "unnamedplus"
  vim.opt.ignorecase = true
  vim.opt.smartcase = true
  vim.opt.updatetime = 250
  vim.opt.virtualedit = "onemore" -- ref https://github.com/vscode-neovim/vscode-neovim/issues/1498

  local vscode = require("vscode")

  -- keymaps

  -- better up/down, also can skip folds
  -- see
  -- https://github.com/vscode-neovim/vscode-neovim/blob/68f056b4c9cb6b2559baa917f8c02166abd86f11/vim/vscode-code-actions.vim#L93-L95
  -- for why using remap = true
  vim.keymap.set(
    { "n", "x" },
    "j",
    "v:count == 0 ? 'gj' : 'j'",
    { desc = "Down", expr = true, silent = true, remap = true }
  )
  vim.keymap.set(
    { "n", "x" },
    "<Down>",
    "v:count == 0 ? 'gj' : 'j'",
    { desc = "Down", expr = true, silent = true, remap = true }
  )
  vim.keymap.set(
    { "n", "x" },
    "k",
    "v:count == 0 ? 'gk' : 'k'",
    { desc = "Up", expr = true, silent = true, remap = true }
  )
  vim.keymap.set(
    { "n", "x" },
    "<Up>",
    "v:count == 0 ? 'gk' : 'k'",
    { desc = "Up", expr = true, silent = true, remap = true }
  )

  -- for folding issue see
  -- https://github.com/vscode-neovim/vscode-neovim/issues/58

  -- fold, only work in normal mode
  -- only open folders when jump into folded code snippets
  vim.keymap.set("n", "zM", function()
    vscode.action("editor.foldAll")
  end)
  vim.keymap.set("n", "zR", function()
    vscode.action("editor.unfoldAll")
  end)
  vim.keymap.set("n", "zc", function()
    vscode.action("editor.fold")
  end)
  vim.keymap.set("n", "zC", function()
    vscode.action("editor.foldRecursively")
  end)
  vim.keymap.set("n", "zo", function()
    vscode.action("editor.unfold")
  end)
  vim.keymap.set("n", "zO", function()
    vscode.action("editor.unfoldRecursively")
  end)
  vim.keymap.set("n", "za", function()
    vscode.action("editor.toggleFold")
  end)

  -- also this, TODO: rewrite it to lua
  vim.cmd([[
  nnoremap <silent> z1 <Cmd>call VSCodeNotify('editor.foldLevel1')<CR>
  nnoremap <silent> z2 <Cmd>call VSCodeNotify('editor.foldLevel2')<CR>
  nnoremap <silent> z3 <Cmd>call VSCodeNotify('editor.foldLevel3')<CR>
  nnoremap <silent> z4 <Cmd>call VSCodeNotify('editor.foldLevel4')<CR>
  nnoremap <silent> z5 <Cmd>call VSCodeNotify('editor.foldLevel5')<CR>
  nnoremap <silent> z6 <Cmd>call VSCodeNotify('editor.foldLevel6')<CR>
  nnoremap <silent> z7 <Cmd>call VSCodeNotify('editor.foldLevel7')<CR>
  ]])

  -- Clear search with <esc>
  vim.keymap.set("n", "<esc>", "<cmd>nohlsearch<cr>", { desc = "Clear hlsearch" })

  -- vscode tab
  vim.keymap.set("n", "<S-H>", "<cmd>Tabprevious<cr>")
  vim.keymap.set("n", "<S-L>", "<cmd>Tabnext<cr>")
  vim.keymap.set("n", "<leader>bd", "<cmd>Tabclose<cr>")
  vim.keymap.set("n", "<leader>bo", "<cmd>Tabonly<cr>")
  vim.keymap.set("n", "<leader>bf", "<cmd>Tabfirst<cr>")
  vim.keymap.set("n", "<leader>bl", "<cmd>Tablast<cr>")

  -- window
  -- vim.keymap.set("n", "<leader>w", "<c-w>", { desc = "<leader>w good", remap = true })
  -- vim.keymap.set("n", "<C-H>", function()
  --   vscode.call("workbench.action.navigateLeft")
  -- end)
  -- vim.keymap.set("n", "<C-L>", function()
  --   vscode.call("workbench.action.navigateRight")
  -- end)
  -- vim.keymap.set("n", "<C-K>", function()
  --   vscode.call("workbench.action.navigateUp")
  -- end)
  -- vim.keymap.set("n", "<C-J>", function()
  --   vscode.call("workbench.action.navigateDown")
  -- end)

  vim.keymap.set("n", "<c-up>", function()
      vscode.action("workbench.action.increaseViewHeight")
    end,
    { desc = "Increase window height" }
  )
  vim.keymap.set("n", "<c-down>", function()
      vscode.action("workbench.action.decreaseViewHeight")
    end,
    { desc = "Decrease window height" }
  )
  vim.keymap.set("n", "<c-left>", function()
      vscode.action("workbench.action.decreaseViewWidth")
    end,
    { desc = "Decrease window height" }
  )
  vim.keymap.set("n", "<c-right>", function()
      vscode.action("workbench.action.increaseViewWidth")
    end,
    { desc = "Increase window height" }
  )


  -- Search
  vim.keymap.set("n", "<leader>sf", function()
    vscode.action("workbench.action.quickOpen")
  end)
  vim.keymap.set("n", "<leader><space>", function()
    vscode.action("workbench.action.quickOpen")
  end)
  -- workbench.action.findInFiles
  vim.keymap.set("n", "<leader>sg", function()
    vscode.action("workbench.action.findInFiles")
  end)
  vim.keymap.set("n", "<leader>ss", function()
    vscode.action("workbench.action.gotoSymbol")
  end)
  vim.keymap.set("n", "<leader>sa", function()
    vscode.action("workbench.action.showAllSymbols")
  end)


  -- format
  vim.keymap.set("n", "<leader>cf", function()
    vscode.action("editor.action.formatDocument")
  end)
  vim.keymap.set("v", "<leader>cf", "<cmd>lua require('vscode').action('editor.action.formatSelection')<cr><esc>")
  vim.keymap.set("n", "<leader>f", function()
    vscode.action("editor.action.formatDocument")
  end)
  vim.keymap.set("v", "<leader>f", "<cmd>lua require('vscode').action('editor.action.formatSelection')<cr><esc>")

  -- lsp
  vim.cmd("nnoremap <nowait> gr gr") -- for neovim 0.11
  vim.keymap.set("n", "gD", function()
    vscode.action("editor.action.revealDeclaration")
  end)
  vim.keymap.set("n", "grr", function()
    vscode.action("editor.action.goToReferences")
  end)
  vim.keymap.set("n", "gri", function()
    vscode.action("editor.action.goToImplementation")
  end)
  vim.keymap.set("n", "grn", function()
    vscode.action("editor.action.rename")
  end)
  vim.keymap.set("n", "gy", function()
    vscode.action("editor.action.goToTypeDefinition")
  end)
  vim.keymap.set("n", "<leader>pd", function()
    vscode.action("editor.action.peekDefinition")
  end)
  vim.keymap.set("n", "<leader>pD", function()
    vscode.action("editor.action.peekDeclaration")
  end)
  vim.keymap.set("n", "<leader>py", function()
    vscode.action("editor.action.peekTypeDefinition")
  end)
  vim.keymap.set({ "n", "v" }, "gra", function()
    vscode.action("editor.action.quickFix")
  end)
  vim.keymap.set("n", "gO", function()
    vscode.action("outline.focus")
  end)

  -- problem
  vim.keymap.set("n", "]d", function()
    vscode.action("editor.action.marker.next")
  end)
  vim.keymap.set("n", "[d", function()
    vscode.action("editor.action.marker.prev")
  end)
  vim.keymap.set("n", "<leader>xx", function()
    vscode.action("workbench.actions.view.problems")
  end)

  -- -- open outline
  -- vim.keymap.set("n", "<leader>cs", function()
  --   vscode.call("workbench.action.toggleAuxiliaryBar")
  --   -- local a = vscode.eval("return vscode.workspace.activeTextEditor")
  --   -- print(a)
  --   -- if a == vim.NIL then
  --   -- call twice
  --   -- vscode.call("outline.focus")
  --   -- vscode.call("outline.focus")
  --   -- else
  --   --   vscode.call("workbench.action.focusFirstEditorGroup")
  --   -- end
  -- end)

  -- explorer
  vim.keymap.set("n", "<leader>e", function()
    vscode.action("workbench.view.explorer")
  end)

  -- side ba[r]
  -- primary
  vim.keymap.set("n", "<leader>h", function()
    vscode.action("workbench.action.toggleSidebarVisibility")
  end)
  -- secondary
  vim.keymap.set("n", "<leader>l", function()
    vscode.action("workbench.action.toggleAuxiliaryBar")
  end)
  -- pane
  vim.keymap.set("n", "<leader>j", function()
    vscode.action("workbench.action.togglePanel")
  end)

  -- clangd
  vim.keymap.set("n", "<leader>ch", function()
    vscode.action("clangd.switchheadersource")
  end)

  -- java
  vim.keymap.set("n", "<leader>co", function()
    vscode.action("editor.action.organizeImports")
  end)

  -- markdown
  vim.keymap.set("n", "<leader>cp", function()
    vscode.action("markdown.showPreviewToSide")
  end)

  -- file
  vim.keymap.del("n", "gf")

  -- bookmark
  vim.keymap.set("n", "<leader>mm", function()
    vscode.action("bookmarks.toggle")
  end)
  vim.keymap.set("n", "<leader>mp", function()
    vscode.action("bookmarks.jumpToNext")
  end)
  vim.keymap.set("n", "<leader>mn", function()
    vscode.action("bookmarks.jumpToPrevious")
  end)

  -- -- debug
  -- vim.keymap.set("n", "<leader>dd", function()
  --   vscode.action("workbench.action.debug.start")
  -- end)
  -- vim.keymap.set("n", "<leader>ds", function()
  --   vscode.action("workbench.action.debug.stop")
  -- end)
  -- vim.keymap.set("n", "<leader>dr", function()
  --   vscode.action("workbench.action.debug.restart")
  -- end)
  -- vim.keymap.set("n", "<leader>dc", function()
  --   vscode.action("workbench.action.debug.continue")
  -- end)
  -- vim.keymap.set("n", "<leader>dk", function()
  --   vscode.action("editor.debug.action.showDebugHover")
  -- end)
  -- vim.keymap.set("n", "<leader>db", function()
  --   vscode.action("editor.debug.action.toggleBreakpoint")
  -- end)
  -- vim.keymap.set("n", "<leader>do", function()
  --   vscode.action("workbench.action.debug.stepOver")
  -- end)
  -- vim.keymap.set("n", "<leader>du", function()
  --   vscode.action("workbench.action.debug.stepOut")
  -- end)
  -- vim.keymap.set("n", "<leader>di", function()
  --   vscode.action("workbench.action.debug.stepInto")
  -- end)

  -- run
  vim.keymap.set({ "n", "v", "o" }, "<leader>re", function()
    vscode.action("mysql.runSQL")
  end)
  vim.keymap.set({ "n", "v", "o" }, "<leader>rs", function()
    vscode.action("mysql.runAllQuery")
  end)

  -- Don't use this because I have found some bugs when using them
  -- e.g. wrong cursor position
  -- -- see https://github.com/vscode-neovim/vscode-neovim/issues/2288
  -- vim.keymap.set('n', 'o', function()
  --   vscode.action('editor.action.insertLineAfter', {
  --     callback = function()
  --       vim.cmd.startinsert({ bang = true })
  --     end,
  --   })
  -- end)
  -- vim.keymap.set('n', 'O', function()
  --   vscode.action('editor.action.insertLineBefore', {
  --     callback = function()
  --       vim.cmd.startinsert({ bang = true })
  --     end,
  --   })
  -- end)

  -- autocmds
  vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = "*",
    command = "setlocal iskeyword-=_",
    desc = "set iskeyword",
  })
  vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
      vim.highlight.on_yank({ higroup = "Search" })
    end,
    desc = "highlight when yanking",
  })
end

-- plugins

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",

      -- I have copy some configs from LazyVim
      event = { "BufReadPost", "BufWritePost", "BufNewFile", "VeryLazy" },
      init = function(plugin)
        -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
        -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
        -- no longer trigger the **nvim-treesitter** module to be loaded in time.
        -- Luckily, the only things that those plugins need are the custom queries, which we make available
        -- during startup.
        require("lazy.core.loader").add_to_rtp(plugin)
        require("nvim-treesitter.query_predicates")
      end,
      cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },

      opts = {
        ensure_installed = {
          "bash",
          "c",
          "cpp",
          -- "diff",
          -- "html",
          "go",
          "java",
          -- "javascript",
          "jsdoc",
          "json",
          "jsonc",
          -- "lua",
          -- "luadoc",
          -- "luap",
          "markdown",
          "markdown_inline",
          -- "printf",
          "python",
          -- "query",
          -- "regex",
          "rust",
          "toml",
          -- "tsx",
          "typescript",
          -- "vim",
          -- "vimdoc",
          "xml",
          "yaml",
        },
        sync_install = false,
        -- Automatically install missing parsers when entering buffer
        auto_install = false,
        -- highlight = { enable = false },
        -- indent = { enable = false },
        -- Incremental selection based on the named nodes from the grammar.
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<c-space>",
            node_incremental = "<c-space>",
            scope_incremental = false,
            node_decremental = "<bs>",
          },
        },
      },
      config = function(_, opts)
        -- Setup
        require("nvim-treesitter.configs").setup(opts)
      end,
    },
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
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
      "Old-Farmer/im-autoswitch.nvim",
      event = "BufEnter",
      opts = {
        cmd = {
          default_im = "1",
          get_im_cmd = "fcitx5-remote",
          switch_im_cmd = "fcitx5-remote -t",
        },
      },
    },
    {
      "folke/flash.nvim",
      event = "VeryLazy",
      ---@type Flash.Config
      opts = {},
      -- stylua: ignore
      keys = {
        { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
        { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
        { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
        { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
        { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
      },
    },
  },
  defaults = {
    lazy = true,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "habamax" } },
  checker = {
    enabled = true,
    notify = false,
  }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
