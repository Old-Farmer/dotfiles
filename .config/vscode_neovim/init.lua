if vim.g.vscode then
  -- Note
  -- Vscode Settings:
  -- 1. try editor.editContext = false maybe fix an input chinese issue,
  --  See https://github.com/vscode-neovim/vscode-neovim/discussions/2498

  -- options
  vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct
  vim.g.maplocalleader = "\\"
  vim.o.ignorecase = true
  vim.o.smartcase = true
  vim.o.timeoutlen = 2000
  vim.o.virtualedit = "onemore" -- ref https://github.com/vscode-neovim/vscode-neovim/issues/1498

  local vscode = require("vscode")
  local map = vim.keymap.set

  -- keymaps

  -- better up/down, also can skip folds
  -- see
  -- https://github.com/vscode-neovim/vscode-neovim/blob/68f056b4c9cb6b2559baa917f8c02166abd86f11/vim/vscode-code-actions.vim#L93-L95
  -- for why using remap = true
  -- key repeat rate must be slower than 20ms / key, then the cursor synchronization between vscode and neovim will work properly
  map({ "n", "v", "x" }, "j", function()
    -- Fix some issues in windows
    local row = vim.api.nvim_win_get_cursor(0)[1]
    local total_lines = vim.api.nvim_buf_line_count(0)
    if row == total_lines then
      return "<Ignore>"
    end
    return vim.v.count == 0 and "gj" or "j"
  end, { desc = "Down", expr = true, silent = true, remap = true })
  map({ "n", "v", "x" }, "k", function()
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

  -- Not set this because win has some shortcut confliction?
  map("n", "<c-up>", function()
    vscode.action("workbench.action.increaseViewHeight")
  end, { desc = "Increase window height" })
  map("n", "<c-down>", function()
    vscode.action("workbench.action.decreaseViewHeight")
  end, { desc = "Decrease window height" })
  map("n", "<c-left>", function()
    vscode.action("workbench.action.decreaseViewWidth")
  end, { desc = "Decrease window width" })
  map("n", "<c-right>", function()
    vscode.action("workbench.action.increaseViewWidth")
  end, { desc = "Increase window width" })

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
  map("n", "<leader>dd", function()
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
      "Old-Farmer/im-autoswitch.nvim",
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
