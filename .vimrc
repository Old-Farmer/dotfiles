unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

let mapleader=' '
let maplocalleader='\\'

" Options
set number
set relativenumber

set mouse=a

set undofile
set undodir=~/.vim/undo//

set ignorecase
set smartcase

set splitright
set splitbelow

set nowrap
set breakindent

set hlsearch

set list
set listchars=tab:\│\ ,trail:-,nbsp:+ " Make tab better 😁
set signcolumn=yes
set smoothscroll

set cursorline
set termguicolors

set noshowcmd
set shortmess+=w

set scrolloff=8

set tabstop=4
set expandtab
set smarttab
set shiftwidth=0 " follow tabstop
set autoindent

set confirm

set foldlevel=99
set foldmethod=indent

set wildoptions=pum,fuzzy
set wildignorecase

set laststatus=2

" Keymaps
noremap <expr> <silent> j v:count == 0 ? 'gj' : 'j'
noremap <expr> <silent> k v:count == 0 ? 'gk' : 'k'

map Y y$

nmap <esc> <cmd>nohlsearch<cr>

nmap <c-left> <cmd>vertical resize -8<cr>
nmap <c-right> <cmd>vertical resize +8<cr>
nmap <c-up> <cmd>resize +4<cr>
nmap <c-down> <cmd>resize -4<cr>

" Autocmds
augroup ft_augroup
  autocmd FileType lua setlocal tabstop=2
  autocmd FileType json setlocal tabstop=2
  autocmd FileType markdown setlocal wrap
  autocmd FileType qf nnoremap <buffer> o <enter><c-w>p
augroup END

" Commands
function s:showMessage()
  let messagesStr = trim(execute('messages'))
  new
  call setbufline(bufnr(), 1, split(messagesStr, '\n'))
  setlocal nobuflisted
  setlocal nomodifiable
  setlocal bufhidden=wipe
  setlocal buftype=nofile
  setlocal noswapfile
  file [MyMessages]
endfunction
command Messages call s:showMessage()

call plug#begin()

Plug 'catppuccin/vim', { 'as': 'catppuccin' }
Plug 'tpope/vim-fugitive'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-commentary'
Plug 'preservim/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'jiangmiao/auto-pairs'

call plug#end()

colorscheme catppuccin_mocha

" coc
inoremap <silent><expr> <c-space> coc#pum#visible() ? coc#pum#cancel() : coc#start()
inoremap <silent><expr> <cr> coc#pum#visible() ? coc#pum#confirm() : '\<cr>'
nnoremap <silent> K <cmd>call ShowDocumentation()<CR>
" Show hover when provider exists, fallback to vim's builtin behavior.
function! ShowDocumentation()
if CocAction('hasProvider', 'hover')
  call CocActionAsync('definitionHover')
else
  call feedkeys('K', 'in')
endif
endfunction

nmap <c-w>d <Plug>(coc-diagnostic-info)
nmap ]d <Plug>(coc-diagnostic-next)
nmap [d <Plug>(coc-diagnostic-prev)

nmap gd <Plug>(coc-definition)
nmap gD <Plug>(coc-declaration)
nmap gra <Plug>(coc-codeaction-cursor)
vmap gra <Plug>(coc-codeaction-selected)
nmap gri <Plug>(coc-implementation)
nmap grn <Plug>(coc-rename)
nmap grr <Plug>(coc-references)
nmap grt <Plug>(coc-type-definition)

nmap <leader>f <Plug>(coc-format)
vmap <leader>f <Plug>(coc-format-selected)

" coc-clangd
nmap <leader>ch <cmd>CocCommand clangd.switchSourceHeader<cr>

" Explorer
nnoremap <leader>e <cmd>NERDTreeToggle<cr>
