-- Neovim configs by CharlieCC

-- General Options, Keymaps, Autocmds, User Commands

vim.cmd([=[
" Options
let mapleader = " "
let maplocalleader = "\\"

set number
set relativenumber

" Schedule time-consuming 'set clipboard'
lua vim.schedule(function() vim.o.clipboard="unnamedplus" end)

set undofile

set ignorecase
set smartcase

set splitright
set splitbelow

set nowrap
set breakindent

set list
set listchars=tab:\│\ ,trail:-,nbsp:+ " Make tab better 😁
set signcolumn=yes
set smoothscroll

set cursorline
set guicursor=
\n-v-c:block,
\i-ci-ve:ver25,
\r-cr:hor20,
\o:hor50,
\a:blinkwait1-blinkoff600-blinkon600-Cursor/lCursor,
\sm:block-blinkwait1-blinkoff600-blinkon600

set noshowcmd
set shortmess+=w

set scrolloff=8

set tabstop=4
set expandtab
set shiftwidth=0 " Follow tabstop

set confirm

set foldlevel=99
set foldmethod=indent

set wildoptions+=fuzzy
set wildignorecase
set completeopt+=fuzzy

set exrc

" Keymaps
noremap <expr> <silent> j v:count == 0 ? "gj" : "j"
noremap <expr> <silent> k v:count == 0 ? "gk" : "k"

nmap <esc> <cmd>nohlsearch<cr>

tnoremap <esc><esc> <c-\><c-n>

nmap <c-left> <cmd>vertical resize -8<cr>
nmap <c-right> <cmd>vertical resize +8<cr>
nmap <c-up> <cmd>resize +4<cr>
nmap <c-down> <cmd>resize -4<cr>

nmap <leader>dl <cmd>lua vim.diagnostic.setloclist()<cr>
nmap <leader>dq <cmd>lua vim.diagnostic.setqflist()<cr>

nmap gd <cmd>lua vim.lsp.buf.definition()<cr>
nmap gD <cmd>lua vim.lsp.buf.declaration()<cr>
nmap grh <cmd>lua vim.lsp.buf.document_highlight()<cr>
nmap grc <cmd>lua vim.lsp.buf.clear_references()<cr>
nmap <leader>cs <cmd>lua vim.lsp.buf.workspace_symbol()<cr>

" Autocmds
augroup ft_augroup
  autocmd FileType lua,json,yaml setlocal tabstop=2
  autocmd FileType markdown setlocal wrap
  autocmd FileType qf nnoremap <buffer> o <enter><c-w>p
augroup END

augroup my_augroup
  autocmd VimLeavePre * if !empty(v:this_session)
  \ | execute "mksession! " .. v:this_session
  \ | endif
  " See :help faq for cursor restore on exit
augroup END

" Commands
function s:bufExecute(cmd)
  let output = trim(execute(a:cmd))
  new
  setlocal nobuflisted
  setlocal bufhidden=wipe
  setlocal buftype=nofile
  setlocal noswapfile
  file [Ex Output]
  call setbufline(bufnr(), 1, split(output, "\n"))
  setlocal nomodifiable
endfunction
command -nargs=+ -complete=command Redir call s:bufExecute(<q-args>)
]=])

-- Plugins and Related Configs

vim.cmd([[
let loaded_netrw = 1
let loaded_netrwPlugin = 1
]])

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
    { "carlos-algms/agentic.nvim" },
    { "saghen/blink.cmp", version = "1.*" },
    { "stevearc/conform.nvim" },
    { "Old-Farmer/im-autoswitch.nvim" },
    { "mason-org/mason.nvim" },
    { "windwp/nvim-autopairs" },
    { "mfussenegger/nvim-lint" },
    { "neovim/nvim-lspconfig" },
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    { "nvim-tree/nvim-web-devicons" }, -- dependency
    { "nvim-tree/nvim-tree.lua" },
    { "tpope/vim-fugitive" },
    { "folke/tokyonight.nvim" },
    { "mbbill/undotree" },
  },
})

-- UI
vim.cmd([[colorscheme tokyonight-night]])

-- Mason
require("mason").setup()
vim.cmd([[
command MasonInstallAll
\ MasonInstall
\ basedpyright
\ clangd
\ tree-sitter-cli
\ lua-language-server
\ shfmt
\ stylua
\ neocmakelsp
\ gopls
\ staticcheck
]])

-- Lsp
local lsp_config = {
  basedpyright = {},
  clangd = {
    cmd = {
      "clangd",
      "--header-insertion=never",
      "--query-driver=/usr/bin/cc,/usr/bin/c++,/usr/bin/gcc*,/usr/bin/g++*,/usr/bin/clang*,/usr/bin/clang++*",
      "--pretty",
      "--background-index",
      "--clang-tidy",
      "--completion-style=detailed",
      "--fallback-style=google",
      "--function-arg-placeholders=false",
    },
  },
  -- https://go.dev/gopls/editor/vim#a-hrefneovim-config-idneovim-configconfigurationa
  gopls = {
    -- https://go.dev/gopls/settings
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
        },
        -- gofumpt = true,
        hints = {
          rangeVariableTypes = true,
          parameterNames = true,
          constantValues = true,
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          functionTypeParameters = true,
        },
        staticcheck = true,
        usePlaceholders = true,
      },
    },
  },
  lua_ls = {
    on_init = function(client)
      if client.workspace_folders then
        local path = client.workspace_folders[1].name
        if
          path ~= vim.fn.stdpath("config")
          and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
        then
          return
        end
      end

      client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
        runtime = {
          -- Tell the language server which version of Lua you're using (most
          -- likely LuaJIT in the case of Neovim)
          version = "LuaJIT",
          -- Tell the language server how to find Lua modules same way as Neovim
          -- (see `:h lua-module-load`)
          path = {
            "lua/?.lua",
            "lua/?/init.lua",
          },
        },
        -- Make the server aware of Neovim runtime files
        workspace = {
          checkThirdParty = false,
          library = {
            vim.env.VIMRUNTIME,
            -- Depending on the usage, you might want to add additional paths
            -- here.
            -- '${3rd}/luv/library',
            -- '${3rd}/busted/library',
          },
          -- Or pull in all of 'runtimepath'.
          -- NOTE: this is a lot slower and will cause issues when working on
          -- your own configuration.
          -- See https://github.com/neovim/nvim-lspconfig/issues/3189
          -- library = vim.api.nvim_get_runtime_file('', true),
        },
      })
    end,
    settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
      },
    },
  },
  neocmake = {},
  rust_analyzer = {
    settings = {
      ["rust-analyzer"] = {
        diagnostics = {
          enable = false,
        },
      },
    },
  },
}
local lsp_onattach = {
  ---@diagnostic disable-next-line: unused-local
  clangd = function(ev)
    vim.cmd([[nmap <buffer> <leader>ch <cmd>LspClangdSwitchSourceHeader<cr>]])
  end,
  ---@diagnostic disable-next-line: unused-local
  gopls = function(ev)
    -- Organize imports
    vim.keymap.set("n", "<leader>co", function()
      vim.lsp.buf.code_action({
        context = {
          only = { "source.organizeImports" },
          diagnostics = {},
        },
        apply = true,
      })
    end, { buffer = true })
  end,
}
for server, config in pairs(lsp_config) do
  vim.lsp.config(server, config)
end
vim.lsp.enable(vim.tbl_keys(lsp_config))
local lsp_group = vim.api.nvim_create_augroup("my.lsp.config", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
  group = lsp_group,
  callback = function(ev)
    -- Skip sth like fugitve://
    if vim.api.nvim_buf_get_name(ev.buf):match("^%a+://") then
      return
    end
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client == nil then
      return
    end

    if client:supports_method(vim.lsp.protocol.Methods.textDocument_codeLens) then
      vim.lsp.codelens.refresh()
    end
    if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      vim.lsp.inlay_hint.enable(true, { bufnr = 0 })
    end

    local onattach = lsp_onattach[client.name]
    if onattach then
      onattach(ev)
    end
  end,
})

-- Treesitter
local ts_lang = {
  "bash",
  "c",
  "cpp",
  "cmake",
  "go",
  "java",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "python",
  "sql",
  "vim",
  "vimdoc",
  "rust",
  "toml",
  "yaml",
}
require("nvim-treesitter").install(ts_lang)
vim.api.nvim_create_autocmd("FileType", {
  pattern = ts_lang,
  callback = function()
    vim.treesitter.start()
    vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.wo[0][0].foldmethod = "expr"
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

-- file tree
require("nvim-tree").setup({
  diagnostics = {
    enable = true,
    debounce_delay = 200,
  },
  filters = {
    enable = false,
  },
  renderer = {
    icons = {
      git_placement = "right_align",
    },
    group_empty = true,
    highlight_hidden = "all",
    indent_markers = {
      enable = true,
    },
  },
})
vim.cmd([[nmap <leader>e <cmd>NvimTreeToggle<cr>]])

-- cmp
require("blink-cmp").setup({
  cmdline = {
    enabled = false,
  },
  keymap = {
    ["<cr>"] = { "select_and_accept", "fallback" },
    ["<C-k>"] = false, -- Use <c-s>
  },
  sources = {
    -- Not use path because sometimes annoying
    default = { "lsp", "snippets", "buffer" },
  },
})

-- format
local conform = require("conform")
conform.setup({
  formatters_by_ft = {
    lua = { "stylua" },
    sh = { "shfmt" },
  },
})
vim.keymap.set({ "n", "v" }, "<leader>f", function()
  conform.format({ async = true, lsp_fallback = true })
end)

-- auto-pair
require("nvim-autopairs").setup()

-- im
require("imas").setup({
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
})

-- ACP
local agentic = require("agentic")
agentic.setup({
  provider = "copilot-acp",
})
vim.keymap.set({ "n" }, "<leader>aa", agentic.toggle)
vim.keymap.set({ "n", "v" }, "<leader>as", agentic.add_selection_or_file_to_context)
vim.keymap.set({ "n" }, "<leader>ar", agentic.restore_session)
vim.keymap.set({ "n" }, "<leader>an", agentic.new_session)
