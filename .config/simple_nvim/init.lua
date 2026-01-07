-- Neovim configs by CharlieCC

-- Options
vim.cmd([=[

let mapleader = " "
let maplocalleader = "\\"

set mouse=a

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
set termguicolors
set smoothscroll
set winborder=shadow

set cursorline
set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait1-blinkoff600-blinkon600-Cursor/lCursor,sm:block-blinkwait1-blinkoff600-blinkon600

set scrolloff=8

set tabstop=4
set expandtab
set smarttab
set shiftwidth=0 " follow tabstop

set confirm

set foldlevel=99
set foldmethod=indent
]=])

vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    vim.cmd("set tabstop=2")
  end,
})

-- Keymaps
vim.cmd([=[

nnoremap <expr> <silent> j v:count == 0 ? 'gj' : 'j'
xnoremap <expr> <silent> j v:count == 0 ? 'gj' : 'j'
nnoremap <expr> <silent> k v:count == 0 ? 'gk' : 'k'
xnoremap <expr> <silent> k v:count == 0 ? 'gk' : 'k'

nmap <esc> <cmd>nohlsearch<cr>

nmap <leader>w <cmd>write<cr>

nmap <leader>qs :mks! ~/sessions/
nmap <leader>ql :source ~/sessions/
]=])

vim.keymap.set("n", "<leader>xl", vim.diagnostic.setloclist, { desc = "diagnostic loclist" })
vim.keymap.set("n", "<leader>xq", vim.diagnostic.setqflist, { desc = "diagnostic qflist" })

vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gD", vim.lsp.buf.declaration)

-- Diagnostic
-- vim.diagnostic.config({
-- 	virtual_text = {
-- 		-- source = "if_many",
-- 		prefix = "●",
-- 	},
-- })

-- Plugins

local pack_changed = function(ev)
  local name, kind = ev.data.spec.name, ev.data.kind

  if name == "nvim-treesitter" and kind == "update" then
    if not ev.data.active then
      vim.cmd.packadd("nvim-treesitter")
    end
    vim.cmd("TSUpdate")
  end

  if name == "telescope-fzf-native.nvim" and (kind == "install" or kind == "update") then
    vim.system({ "make" }, { cwd = ev.data.path }):wait()
  end
end

vim.api.nvim_create_autocmd("PackChanged", { callback = pack_changed })

local function gh(path)
  return "https://github.com/" .. path
end
vim.pack.add({
  {
    src = gh("saghen/blink.cmp"),
    version = vim.version.range("1.*"),
  },
  { src = gh("catppuccin/nvim"), name = "catppuccin" },

  gh("stevearc/conform.nvim"),
  gh("folke/lazydev.nvim"), -- Just for lua config dev
  gh("mason-org/mason.nvim"),
  gh("mfussenegger/nvim-lint"),
  gh("neovim/nvim-lspconfig"),
  gh("nvim-treesitter/nvim-treesitter"),
  gh("nvim-tree/nvim-web-devicons"), -- dependency
  gh("stevearc/oil.nvim"),
  gh("nvim-lua/plenary.nvim"), -- dependency
  gh("nvim-telescope/telescope-fzf-native.nvim"),
  gh("nvim-telescope/telescope.nvim"),
})

-- colorscheme
vim.cmd("colorscheme catppuccin")

-- Mason
require("mason").setup()
vim.api.nvim_create_user_command("MasonInstallAll", function()
  local tools = { "clangd", "tree-sitter-cli", "lua-language-server", "shfmt", "stylua", "cmake-language-server" }
  vim.cmd("MasonInstall" .. table.concat(tools, " "))
end, {})

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

vim.api.nvim_create_autocmd("LspProgress", {
  group = lsp_group,
  callback = function(ev)
    local value = ev.data.params.value
    if value.kind == "begin" or value.kind == "report" then
      vim.notify("Lsp Progress: " .. vim.lsp.status())
    elseif value.kind == "end" then
      vim.notify("Lsp progress: Done")
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
vim.lsp.enable({ "clangd", "lua_ls", "cmake" })
vim.cmd("nmap <leader>ch <cmd>LspClangdSwitchSourceHeader<cr>")

-- Treesitter
local ts_lang = { "c", "cpp", "lua", "cmake", "vim", "vimdoc" }
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

-- fuzzy finder
require("telescope").setup({
  -- file_ignore_patterns = {
  -- 	"build.*/",
  -- },
})
require("telescope").load_extension("fzf")
vim.cmd([[
nmap <leader><space> <cmd>Telescope find_files<cr>
nmap <leader>, <cmd>Telescope buffers<cr>
]])

-- file tree
require("oil").setup({
  keymaps = {
    ["<leader>e"] = { "actions.close", mode = "n" },
  },
})
vim.cmd([[
nmap <leader>e <cmd>Oil<cr>
]])

-- cmp
require("blink-cmp").setup({
  cmdline = {
    enabled = false,
  },
  keymap = {
    ["<cr>"] = { "select_and_accept", "fallback" },
    -- ["<c-k>"] = false,
  },
})

-- format
require("conform").setup({
  notify_on_error = false,
  formatters_by_ft = {
    lua = { "stylua" },
    sh = { "shfmt" },
  },
})

local conform = require("conform")
vim.keymap.set("n", "<leader>f", function()
  conform.format({ async = true, lsp_fallback = true })
end)
