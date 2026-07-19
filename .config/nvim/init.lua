-- Neovim configs by CharlieCC

local map = vim.keymap.set
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- General Options, Keymaps, Autocmds, User Commands

vim.cmd([=[
" Options
let mapleader = " "
let maplocalleader = "\\"

set number
set relativenumber

" Schedule time-consuming 'set clipboard'
" lua vim.schedule(function() vim.o.clipboard="unnamedplus" end)

set timeoutlen=10000

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
set guifont=JetbrainsMono\ Nerd\ Font:h12
set guicursor=
\n-v-c:block,
\i-ci-ve:ver25,
\r-cr:hor20,
\o:hor50,
\a:blinkwait150-blinkoff600-blinkon600-Cursor/lCursor,
\sm:block-blinkwait150-blinkoff600-blinkon600

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

set path+=**

if exists("g:neovide")
  let g:neovide_padding_top = 10
  let g:neovide_padding_right = 5
  let g:neovide_padding_left = 5
  let g:neovide_cursor_animation_length = 0.05
  let g:neovide_scroll_animation_length = 0.1
  " let g:neovide_cursor_smooth_blink = v:true
  let g:neovide_cursor_trail_size = 0.6
  " let g:neovide_cursor_animate_command_line = v:false
  let g:neovide_cursor_hack = v:false
  let g:neovide_cursor_unfocused_outline_width = 0.05
endif

" Keymaps
noremap <expr> <silent> j v:count == 0 ? "gj" : "j"
noremap <expr> <silent> k v:count == 0 ? "gk" : "k"
sunmap j
sunmap k

nmap <esc> <cmd>nohlsearch<cr>

" Better builtin terminal
tnoremap <m-w> <c-\><c-n><c-w>
tnoremap <m-w><m-w> <m-w>
tnoremap <m-w>: <c-\><c-o>:

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
  autocmd!
  autocmd FileType lua,json,yaml setlocal tabstop=2
  autocmd FileType markdown setlocal wrap
  autocmd FileType qf nnoremap <buffer> o <enter><c-w>p
augroup END

augroup my_augroup
  autocmd!
  autocmd VimLeavePre * if !empty(v:this_session)
  \ | execute "mksession! " .. v:this_session
  \ | endif
  " See :help faq for cursor restore on exit
augroup END

augroup term_auto_insert
    autocmd!
    autocmd BufEnter term://* startinsert
    autocmd BufLeave term://* stopinsert
    autocmd TermOpen term://* startinsert
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

-- Float Terminal
local function fullscreen_float(buf)
  buf = buf or vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = vim.o.columns,
    height = vim.o.lines - 1,
    row = 0,
    col = 0,
    style = "minimal",
    border = "none",
  })
  return win, buf
end

local term_buf, float_term_win
local function toggle_terminal()
  if float_term_win then
    vim.api.nvim_win_close(0, false)
    float_term_win = nil
    return
  end

  if term_buf then
    float_term_win = fullscreen_float(term_buf)
  else
    float_term_win, term_buf = fullscreen_float()
    -- vim.cmd("keepalt keepjumps terminal")
    vim.cmd.terminal()
    vim.bo.buflisted = false
    vim.api.nvim_create_autocmd("BufUnload", {
      buf = term_buf,
      callback = function()
        term_buf = nil
        float_term_win = nil
      end,
    })
  end
end
map({ "n", "t" }, "<c-/>", toggle_terminal)
map({ "n", "t" }, "<c-_>", toggle_terminal)

-- Plugins and Related Configs

vim.cmd([[
let loaded_netrw = 1
let loaded_netrwPlugin = 1
packadd nvim.undotree
]])

autocmd("PackChanged", {
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

-- Dependencies
vim.pack.add({
  gh("nvim-tree/nvim-web-devicons"),
})

vim.pack.add({
  gh("carlos-algms/agentic.nvim"),
  {
    src = gh("saghen/blink.cmp"),
    version = vim.version.range("1.*"),
  },
  gh("stevearc/conform.nvim"),
  gh("Old-Farmer/im-autoswitch.nvim"),
  gh("brianhuster/live-preview.nvim"),
  gh("mason-org/mason.nvim"),
  gh("windwp/nvim-autopairs"),
  gh("mfussenegger/nvim-jdtls"),
  gh("mfussenegger/nvim-lint"),
  gh("neovim/nvim-lspconfig"),
  gh("nvim-treesitter/nvim-treesitter"),
  gh("nvim-tree/nvim-tree.lua"),
  gh("tpope/vim-fugitive"),
  gh("folke/tokyonight.nvim"),
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
\ gopls
\ jdtls
\ json-lsp
\ lua-language-server
\ neocmakelsp
\ shfmt
\ stylua
\ staticcheck
\ tree-sitter-cli
\ zls
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
      "--log=error", -- avoid too large log
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
  jdtls = {},
  jsonls = {
    -- See
    -- https://github.com/microsoft/vscode/blob/main/extensions/json-language-features/package.json
    -- contributes.configuration.properties
    settings = {
      json = {
        keepLines = { enable = true },
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
  zls = {},
}
local lsp_onattach = {
  ---@diagnostic disable-next-line: unused-local
  clangd = function(ev)
    vim.cmd([[nmap <buffer> <leader>ch <cmd>LspClangdSwitchSourceHeader<cr>]])
  end,
  ---@diagnostic disable-next-line: unused-local
  gopls = function(ev)
    -- Organize imports
    map("n", "<leader>co", function()
      vim.lsp.buf.code_action({
        context = {
          only = { "source.organizeImports" },
          diagnostics = {},
        },
        apply = true,
      })
    end, { buffer = true })
  end,
  ---@diagnostic disable-next-line: unused-local
  jdtls = function(ev)
    vim.cmd([[nmap <buffer> <leader>co <cmd>lua require("jdtls").organize_imports()<cr>]])
  end,
}
for server, config in pairs(lsp_config) do
  vim.lsp.config(server, config)
end
vim.lsp.enable(vim.tbl_keys(lsp_config))
local lsp_group = augroup("my.lsp.config", { clear = true })
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

    -- codelens is not that good support in neovim, disable it now.
    -- if client:supports_method(vim.lsp.protocol.Methods.textDocument_codeLens) then
    --   vim.lsp.codelens.enable(true)
    -- end
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
local ts_ensure_installed_lang = {
  "bash",
  "cpp",
  "cmake",
  "go",
  "java",
  "json",
  "python",
  "sql",
  "rust",
  "toml",
  "yaml",
}
local ts_lang = {
  "c",
  "lua",
  "markdown",
  "markdown_inline",
  "vim",
  "vimdoc",
}
vim.list_extend(ts_lang, ts_ensure_installed_lang)
require("nvim-treesitter").install(ts_ensure_installed_lang)
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
    ["<c-k>"] = false, -- Use <c-s>
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
map({ "n", "v" }, "<leader>f", function()
  conform.format({ async = true, lsp_fallback = true })
end)

-- auto-pair
require("nvim-autopairs").setup()

-- ime
if vim.g.neovide then
  local function set_ime(args)
    if args.event:match("Enter$") then
      vim.g.neovide_input_ime = true
    else
      vim.g.neovide_input_ime = false
    end
  end

  local ime_input = augroup("ime_input", { clear = true })

  autocmd({ "InsertEnter", "InsertLeave" }, {
    group = ime_input,
    pattern = "*",
    callback = set_ime,
  })

  autocmd({ "CmdlineEnter", "CmdlineLeave" }, {
    group = ime_input,
    pattern = "[/\\?]",
    callback = set_ime,
  })
else
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
end

-- markdown preview
require("livepreview.config").set({
  port = 5500,
  browser = "default",
  dynamic_root = false,
  sync_scroll = true,
  picker = "",
  address = "127.0.0.1",
})

-- ACP
local agentic = require("agentic")
agentic.setup({
  provider = "copilot-acp",
})
map({ "n" }, "<leader>aa", agentic.toggle)
map({ "n", "v" }, "<leader>as", agentic.add_selection_or_file_to_context)
map({ "n" }, "<leader>ar", agentic.restore_session)
map({ "n" }, "<leader>an", agentic.new_session)
