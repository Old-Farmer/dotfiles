-- A neovim config written by Shixin Chai
-- Highly ref kickstart.nvim & LazyVim

Easynvim = require("easynvim")

require("options")
require("cmds")
require("keymaps")
require("autocmds")
require("term-emulator")

pcall(require, "gitignore_config")

require("lazy_nvim")
