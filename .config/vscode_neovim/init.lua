if vim.g.vscode then
  -- Note
  -- Vscode Settings:
  -- 1. try editor.editContext = false maybe fix an input chinese issue,
  --  See https://github.com/vscode-neovim/vscode-neovim/discussions/2498

  -- options
  vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct
  vim.g.maplocalleader = " " -- Same for `maplocalleader`
  vim.o.clipboard = "unnamedplus"
  vim.o.ignorecase = true
  vim.o.smartcase = true
  vim.o.timeoutlen = 2000
  vim.o.updatetime = 250
  vim.o.virtualedit = "onemore" -- ref https://github.com/vscode-neovim/vscode-neovim/issues/1498
  vim.o.mouse = "a"

  local vscode = require("vscode")
  local map = vim.keymap.set

  -- keymaps

  -- better up/down, also can skip folds
  -- see
  -- https://github.com/vscode-neovim/vscode-neovim/blob/68f056b4c9cb6b2559baa917f8c02166abd86f11/vim/vscode-code-actions.vim#L93-L95
  -- for why using remap = true
  -- key repeat rate must be slower than 20ms / key, then the cursor synchronization between vscode and neovim will work properly
  map({ "n", "x" }, "j", function()
    -- Fix some issues in windows
    local row = vim.api.nvim_win_get_cursor(0)[1]
    local total_lines = vim.api.nvim_buf_line_count(0)
    if row == total_lines then
      return "<Ignore>"
    end
    return vim.v.count == 0 and "gj" or "j"
  end, { desc = "Down", expr = true, silent = true, remap = true })
  map({ "n", "x" }, "k", function()
    local row = vim.api.nvim_win_get_cursor(0)[1]
    if row == 1 then
      return "<Ignore>"
    end
    return vim.v.count == 0 and "gk" or "k"
  end, { desc = "Up", expr = true, silent = true, remap = true })

  -- for folding issue see
  -- https://github.com/vscode-neovim/vscode-neovim/issues/58

  -- fold, only work in normal mode
  -- only open folders when jump into folded code snippets
  map("n", "zM", function()
    vscode.action("editor.foldAll")
  end)
  map("n", "zR", function()
    vscode.action("editor.unfoldAll")
  end)
  map("n", "zc", function()
    vscode.action("editor.fold")
  end)
  map("n", "zC", function()
    vscode.action("editor.foldRecursively")
  end)
  map("n", "zo", function()
    vscode.action("editor.unfold")
  end)
  map("n", "zO", function()
    vscode.action("editor.unfoldRecursively")
  end)
  map("n", "za", function()
    vscode.action("editor.toggleFold")
  end)

  -- also this
  map("n", "z1", function()
    vscode.action("editor.foldLevel1")
  end)
  map("n", "z2", function()
    vscode.action("editor.foldLevel2")
  end)
  map("n", "z3", function()
    vscode.action("editor.foldLevel3")
  end)
  map("n", "z4", function()
    vscode.action("editor.foldLevel4")
  end)
  map("n", "z5", function()
    vscode.action("editor.foldLevel5")
  end)
  map("n", "z6", function()
    vscode.action("editor.foldLevel6")
  end)
  map("n", "z7", function()
    vscode.action("editor.foldLevel7")
  end)

  -- Clear search with <esc>
  map("n", "<esc>", "<cmd>nohlsearch<cr>", { desc = "Clear hlsearch" })

  -- Save
  map("n", "<leader>w", "<cmd>write<cr><esc>", { desc = "Save file" })

  -- vscode tab
  -- In Vscode Neovim, buffers cmds & keymaps can't work now, so I create some.
  map("n", "<S-H>", "<cmd>Tabprevious<cr>")
  map("n", "<S-L>", "<cmd>Tabnext<cr>")
  map("n", "[b", "<cmd>Tabprevious<cr>")
  map("n", "]b", "<cmd>Tabnext<cr>")
  map("n", "<leader>bd", "<cmd>Tabclose<cr>")
  map("n", "<leader>bo", "<cmd>Tabonly<cr>")
  map("n", "<leader>bf", "<cmd>Tabfirst<cr>")
  map("n", "<leader>bl", "<cmd>Tablast<cr>")

  -- window
  -- map("n", "<C-H>", function()
  --   vscode.call("workbench.action.navigateLeft")
  -- end)
  -- map("n", "<C-L>", function()
  --   vscode.call("workbench.action.navigateRight")
  -- end)
  -- map("n", "<C-K>", function()
  --   vscode.call("workbench.action.navigateUp")
  -- end)
  -- map("n", "<C-J>", function()
  --   vscode.call("workbench.action.navigateDown")
  -- end)

  -- Not set this because win has some shortcut confliction
  -- map("n", "<c-up>", function()
  --   vscode.action("workbench.action.increaseViewHeight")
  -- end, { desc = "Increase window height" })
  -- map("n", "<c-down>", function()
  --   vscode.action("workbench.action.decreaseViewHeight")
  -- end, { desc = "Decrease window height" })
  -- map("n", "<c-left>", function()
  --   vscode.action("workbench.action.decreaseViewWidth")
  -- end, { desc = "Decrease window width" })
  -- map("n", "<c-right>", function()
  --   vscode.action("workbench.action.increaseViewWidth")
  -- end, { desc = "Increase window width" })

  -- Search
  map("n", "<leader><space>", function()
    vscode.action("workbench.action.quickOpen")
  end)
  map("n", "<leader>sa", function()
    vscode.action("workbench.action.showAllSymbols")
  end)
  map("n", "<leader>sf", function()
    vscode.action("workbench.action.files.openFile")
  end)
  -- workbench.action.findInFiles
  map("n", "<leader>sg", function()
    vscode.action("workbench.action.findInFiles")
  end)
  map("n", "<leader>so", function()
    vscode.action("workbench.action.gotoSymbol")
  end)

  -- format
  map("n", "<leader>cf", function()
    vscode.action("editor.action.formatDocument")
  end)
  map("v", "<leader>cf", "<cmd>lua require('vscode').action('editor.action.formatSelection')<cr><esc>")
  map("n", "<leader>f", function()
    vscode.action("editor.action.formatDocument")
  end)
  map("v", "<leader>f", "<cmd>lua require('vscode').action('editor.action.formatSelection')<cr><esc>")

  -- lsp
  map("n", "gD", function()
    vscode.action("editor.action.revealDeclaration")
  end)
  map("n", "grr", function()
    vscode.action("editor.action.goToReferences")
  end)
  map("n", "gri", function()
    vscode.action("editor.action.goToImplementation")
  end)
  map("n", "grn", function()
    vscode.action("editor.action.rename")
  end)
  map("n", "grt", function()
    vscode.action("editor.action.goToTypeDefinition")
  end)
  map("n", "<leader>pd", function()
    vscode.action("editor.action.peekDefinition")
  end)
  map("n", "<leader>pD", function()
    vscode.action("editor.action.peekDeclaration")
  end)
  map("n", "<leader>pi", function()
    vscode.action("editor.action.peekImplementation")
  end)
  map("n", "<leader>py", function()
    vscode.action("editor.action.peekTypeDefinition")
  end)
  map({ "n", "v" }, "gra", function()
    vscode.action("editor.action.quickFix")
  end)
  map("n", "gO", function()
    vscode.action("outline.focus")
  end)

  -- problem
  map("n", "]d", function()
    vscode.action("editor.action.marker.next")
  end)
  map("n", "[d", function()
    vscode.action("editor.action.marker.prev")
  end)
  map("n", "<leader>xx", function()
    vscode.action("workbench.actions.view.problems")
  end)

  -- -- open outline
  -- map("n", "<leader>cs", function()
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
  map("n", "<leader>e", function()
    vscode.action("workbench.view.explorer")
  end)

  -- side bar
  -- primary
  map("n", "<leader>h", function()
    vscode.action("workbench.action.toggleSidebarVisibility")
  end)
  -- secondary
  map("n", "<leader>l", function()
    vscode.action("workbench.action.toggleAuxiliaryBar")
  end)
  -- pane
  map("n", "<leader>j", function()
    vscode.action("workbench.action.togglePanel")
  end)

  -- clangd
  map("n", "<leader>ch", function()
    vscode.action("clangd.switchheadersource")
  end)
  map("n", "<leader>ct", function()
    vscode.action("clangd.typeHierarchy")
  end)

  -- java
  map("n", "<leader>co", function()
    vscode.action("editor.action.organizeImports")
  end)

  -- markdown
  map("n", "<leader>cp", function()
    vscode.action("markdown.showPreviewToSide")
  end)

  -- file
  vim.keymap.del("n", "gf")

  -- bookmark
  map("n", "<leader>mm", function()
    vscode.action("bookmarks.toggle")
  end)
  map("n", "<leader>mp", function()
    vscode.action("bookmarks.jumpToNext")
  end)
  map("n", "<leader>mn", function()
    vscode.action("bookmarks.jumpToPrevious")
  end)

  -- -- debug
  -- map("n", "<leader>dd", function()
  --   vscode.action("workbench.action.debug.start")
  -- end)
  -- map("n", "<leader>ds", function()
  --   vscode.action("workbench.action.debug.stop")
  -- end)
  -- map("n", "<leader>dr", function()
  --   vscode.action("workbench.action.debug.restart")
  -- end)
  -- map("n", "<leader>dc", function()
  --   vscode.action("workbench.action.debug.continue")
  -- end)
  -- map("n", "<leader>dk", function()
  --   vscode.action("editor.debug.action.showDebugHover")
  -- end)
  -- map("n", "<leader>db", function()
  --   vscode.action("editor.debug.action.toggleBreakpoint")
  -- end)
  -- map("n", "<leader>do", function()
  --   vscode.action("workbench.action.debug.stepOver")
  -- end)
  -- map("n", "<leader>du", function()
  --   vscode.action("workbench.action.debug.stepOut")
  -- end)
  -- map("n", "<leader>di", function()
  --   vscode.action("workbench.action.debug.stepInto")
  -- end)

  -- run
  map({ "n", "v", "o" }, "<leader>re", function()
    vscode.action("mysql.runSQL")
  end)
  map({ "n", "v", "o" }, "<leader>rs", function()
    vscode.action("mysql.runAllQuery")
  end)

  -- Don't use this because I have found some bugs when using them
  -- e.g. wrong cursor position
  -- -- see https://github.com/vscode-neovim/vscode-neovim/issues/2288
  -- map('n', 'o', function()
  --   vscode.action('editor.action.insertLineAfter', {
  --     callback = function()
  --       vim.cmd.startinsert({ bang = true })
  --     end,
  --   })
  -- end)
  -- map('n', 'O', function()
  --   vscode.action('editor.action.insertLineBefore', {
  --     callback = function()
  --       vim.cmd.startinsert({ bang = true })
  --     end,
  --   })
  -- end)
  --
  vim.api.nvim_create_user_command("RemoveCR", function()
    vim.cmd([[%s/\r$//g]])
  end, { force = true })

  -- autocmds
  -- vim.api.nvim_create_autocmd({ "FileType" }, {
  --   pattern = "*",
  --   command = "setlocal iskeyword-=_",
  --   desc = "set iskeyword",
  -- })
  vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
      vim.hl.on_yank({ higroup = "Search" })
    end,
    desc = "highlight when yanking",
  })

  -- vim.api.nvim_create_autocmd("InsertEnter", {
  --   callback = function()
  --     -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("a<BS>", true, false, true), "n", false)
  --     -- local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  --     -- vim.api.nvim_win_set_cursor(0, { row, col })
  --     vscode.action("_ping")
  --   end,
  -- })
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
      { out, "WarningMsg" },
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
      "mason-org/mason.nvim",
      -- mason.nvim is optimized to load as little as possible during setup.
      -- Lazy-loading the plugin, or somehow deferring the setup, is not recommended.
      lazy = false,
      opts = {
        ensure_installed = {
          "tree-sitter-cli",
        },
      },
      config = function(_, opts)
        require("mason").setup(opts)
        local mr = require("mason-registry")
        mr.refresh(function()
          for _, pkg in ipairs(opts.ensure_installed) do
            if not mr.is_installed(pkg) then
              vim.cmd("MasonInstall " .. pkg)
            end
          end
        end)
      end,
    },
    {
      "nvim-treesitter/nvim-treesitter",
      dependencies = { "mason-org/mason.nvim" },
      build = ":TSUpdate",
      branch = "main",
      lazy = false,
      opts = {
        ensure_installed = {
          "awk",
          "bash",
          -- "c",
          "cmake",
          "cpp",
          -- "diff",
          -- "html",
          "go",
          "java",
          "javascript",
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
      },
      config = function(_, opts)
        local nvim_treesitter = require("nvim-treesitter")
        nvim_treesitter.setup({
          -- Directory to install parsers and queries to
          install_dir = vim.fn.stdpath("data") .. "/site",
        })
        nvim_treesitter.install(opts.ensure_installed)
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
      "Old-Farmer/im-autoswitch.nvim",
      dev = true,
      event = "BufEnter",
      opts = {
        cmd_os = {
          linux = {
            default_im = "keyboard-us",
            get_im_cmd = "fcitx5-remote -n",
            switch_im_cmd = "fcitx5-remote -s {}",
          },
          macos = {
            default_im = "com.apple.keylayout.ABC",
            get_im_cmd = "im-select",
            switch_im_cmd = "im-select {}",
          },
          windows = {
            default_im = "1033", -- 2052
            get_im_cmd = "im-select.exe",
            switch_im_cmd = "im-select.exe {}",
          },
        },
        mode = {
          terminal = false,
        },
        check_wsl = true,
      },
    },
    {
      "folke/flash.nvim",
      dependencies = { "nvim-treesitter/nvim-treesitter" },
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
    -- {
    --   "xiyaowong/fast-cursor-move.nvim",
    --   event = "VeryLazy",
    -- },
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
