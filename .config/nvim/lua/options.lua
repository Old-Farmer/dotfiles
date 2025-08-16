-- Options and global configs

-- Global config
Global_config = {
  im = true,
  languages = {
    c_cpp = true,
    markdown = true,
  },
}

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- leader key, must before lazy.nvim load
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- termdebug
vim.g.termdebug_config = {
  wide = 1,
}

local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

opt.mouse = "a" -- Enable mouse

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  -- only set clipboard if not in ssh, to make sure the OSC 52
  -- integration works automatically. Requires Neovim >= 0.10.0
  opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard
end)

opt.breakindent = true -- Break indent
opt.undofile = true -- Undo history

-- Case-Insensitive search
opt.ignorecase = true
opt.smartcase = true

opt.signcolumn = "yes" -- Keep sign column always visible
opt.updatetime = 300 -- Save swap file and trigger CursorHold
opt.timeoutlen = 300 -- Trigger which-key quickly

-- Splitting windows position
opt.splitright = true
opt.splitbelow = true

opt.list = true -- Show tabs, trailing spaces and non-breakable
opt.cursorline = true -- Highlight the line of cursor
opt.scrolloff = 8 -- Scroll off

-- Cursor style
opt.guicursor =
  "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait1-blinkoff600-blinkon600-Cursor/lCursor,sm:block-blinkwait1-blinkoff600-blinkon600"

-- tab behaivor
opt.tabstop = 4
opt.expandtab = true
opt.smarttab = true

-- opt.smartindent = true -- Indent smartly
opt.shiftwidth = 4 -- Shift width
opt.confirm = true -- Confirm to save changes before exiting modified buffer
-- opt.autowrite = true
opt.termguicolors = true -- 24 bits true color support
opt.wrap = false -- No wrap lines

-- fold
opt.foldlevel = 99
opt.foldmethod = "indent"

opt.smoothscroll = true -- Scroll smoothly
-- opt.formatoptions = "jcroql" -- Default option value, not tcqj in vim help
opt.laststatus = 3 -- Only one statusline
opt.showmode = false -- Don't show mode
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

-- https://www.barbarianmeetscoding.com/notes/neovim/diagnostics/
-- NOTE: Diagnostics is actually independent to lsp, so I set it here
-- Global diagnostics config
vim.diagnostic.config({
  virtual_text = {
    -- source = "if_many",
    prefix = "●",
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = "󰌵",
    },
  },
})

-- neovide
if vim.g.neovide then
  vim.o.guifont = "JetbrainsMono Nerd Font:h14"
  vim.g.neovide_transparency = 0.98
  vim.g.neovide_padding_top = 10
  vim.g.neovide_padding_right = 5
  vim.g.neovide_padding_left = 5
  vim.g.neovide_cursor_animation_length = 0.05
  vim.g.neovide_scroll_animation_length = 0.1
  vim.g.neovide_cursor_animate_in_insert_mode = false
  vim.g.neovide_cursor_animate_command_line = false
  vim.g.neovide_cursor_trail_size = 0.4
end
