-- Neovim configs by CharlieCC

vim.cmd([=[
" Options
let mapleader = " "
let maplocalleader = "\\"

set clipboard=unnamedplus

set number
set relativenumber

set undofile

set ignorecase
set smartcase

set splitright
set splitbelow

set nowrap
set breakindent

set list
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
set smarttab
set shiftwidth=0 " follow tabstop

set confirm

set foldlevel=99
set foldmethod=indent

set wildoptions+=fuzzy
set wildignorecase
set completeopt+=fuzzy

" Keymaps
noremap <expr> <silent> j v:count == 0 ? 'gj' : 'j'
noremap <expr> <silent> k v:count == 0 ? 'gk' : 'k'

nmap <esc> <cmd>nohlsearch<cr>

nmap <leader>w <cmd>write<cr>

nmap <leader><leader> :b<space>

nmap <c-left> <cmd>vertical resize -8<cr>
nmap <c-right> <cmd>vertical resize +8<cr>
nmap <c-up> <cmd>resize +4<cr>
nmap <c-down> <cmd>resize -4<cr>

nmap <leader>ss :mksession! ~/sessions/
nmap <leader>sS :exe "mksession! " .. v:this_session
nmap <leader>sl :source ~/sessions/

nmap <leader>dl <cmd>lua vim.diagnostic.setloclist()<cr>
nmap <leader>dq <cmd>lua vim.diagnostic.setqflist()<cr>

nmap gd <cmd>lua vim.lsp.buf.definition()<cr>
nmap gD <cmd>lua vim.lsp.buf.declaration()<cr>

" autocmds
augroup ft_augroup
  autocmd FileType lua setlocal tabstop=2
  autocmd FileType markdown setlocal wrap
  autocmd FileType qf nnoremap <buffer> o <enter><c-w>p
augroup END
]=])

-- Diagnostic
-- vim.diagnostic.config({
--   virtual_text = {
--     -- source = "if_many",
--     prefix = "●",
--   },
-- })

-- Plugins
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == "nvim-treesitter" and kind == "update" then
      if not ev.data.active then
        vim.cmd("packadd nvim-treesitter")
      end
      vim.cmd("TSUpdate")
    end
  end,
})

local function gh(path)
  return "https://github.com/" .. path
end
vim.pack.add({
  {
    src = gh("saghen/blink.cmp"),
    version = vim.version.range("1.*"),
  },
  gh("stevearc/conform.nvim"),
  gh("folke/lazydev.nvim"), -- Just for lua config dev
  gh("lewis6991/gitsigns.nvim"),
  gh("mason-org/mason.nvim"),
  gh("windwp/nvim-autopairs"),
  gh("mfussenegger/nvim-lint"),
  gh("neovim/nvim-lspconfig"),
  gh("nvim-treesitter/nvim-treesitter"),
  gh("nvim-tree/nvim-web-devicons"), -- dependency
  gh("nvim-tree/nvim-tree.lua"),
  gh("folke/tokyonight.nvim"),
  gh("tpope/vim-fugitive"),
})

-- UI
require("tokyonight").setup()
vim.cmd([[colorscheme tokyonight-night]])

-- Mason
require("mason").setup()
vim.cmd([[
command MasonInstallAll
\ clangd
\ tree-sitter-cli
\ lua-language-server
\ shfmt
\ stylua
\ neocmakelsp
\ gopls
]])

-- Lsp
local lsp_group = vim.api.nvim_create_augroup("my.lsp.config", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = lsp_group,
  pattern = "lua",
  callback = function()
    require("lazydev").setup({
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    })
  end,
  once = true,
})
vim.api.nvim_create_autocmd("LspAttach", {
  group = lsp_group,
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end

    if client:supports_method(vim.lsp.protocol.Methods.textDocument_codeLens) then
      vim.lsp.codelens.refresh()
    end

    if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      vim.lsp.inlay_hint.enable(true, { bufnr = 0 })
    end
  end,
})
-- LspProgress
local lsp_progress = {}
vim.api.nvim_create_autocmd("LspProgress", {
  group = lsp_group,
  callback = function(ev)
    local value = ev.data.params.value
    local client_id = ev.data.client_id
    local token = ev.data.params.token

    if value.kind == "begin" then
      local client = vim.lsp.get_client_by_id(client_id)
      if not client then
        return
      end
      if not lsp_progress[client_id] then
        lsp_progress[client_id] = {}
      end
      local progress = {
        kind = "progress",
        status = "running",
        percent = value.percentage,
        title = string.format("LspProgress(%s[%d])", client.name, client_id),
      }
      lsp_progress[client_id][token] = progress
      progress.id = vim.api.nvim_echo({ { value.title } }, false, progress)
      return
    end

    local progress = lsp_progress[client_id][token]
    if value.kind == "report" then
      progress.percent = value.percentage
      vim.api.nvim_echo({ { value.title } }, false, progress)
    else
      progress.percent = 100
      progress.status = "success"
      vim.api.nvim_echo({ { value.title } }, true, progress)
      lsp_progress[client_id][token] = nil
      if not next(lsp_progress[client_id]) then
        lsp_progress[client_id] = nil
      end
    end
  end,
})

-- clangd
vim.lsp.config("clangd", {
  cmd = {
    "clangd",
    "--header-insertion=never",
    "--query-driver=/usr/bin/cc,/usr/bin/c++,/usr/bin/gcc*,/usr/bin/g++*,/usr/bin/clang*,/usr/bin/clang++*",
    "--pretty",
    "--background-index",
    "--clang-tidy",
    "--completion-style=detailed",
    "--fallback-style=google",
  },
})
vim.cmd([[nmap <leader>ch <cmd>LspClangdSwitchSourceHeader<cr>]])
-- lua_ls
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
})
vim.lsp.enable({
  "clangd",
  "gopls",
  "lua_ls",
  "neocmake",
})

-- Treesitter
local ts_lang = {
  "bash",
  "c",
  "cpp",
  "cmake",
  "go",
  "java",
  "lua",
  "markdown",
  "python",
  "vim",
  "vimdoc",
  "rust",
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
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
require("nvim-tree").setup({
  diagnostics = {
    enable = true,
    debounce_delay = 200,
  },
  filters = {
    enable = false,
  },
  renderer = {
    icons = { git_placement = "right_align" },
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
  cmdline = { enabled = false },
  keymap = {
    ["<cr>"] = { "select_and_accept", "fallback" },
  },
  sources = {
    -- Not use path because sometimes annoying
    default = { "lsp", "snippets", "buffer" },
  },
})

-- format
local conform = require("conform")
conform.setup({
  notify_on_error = false,
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
