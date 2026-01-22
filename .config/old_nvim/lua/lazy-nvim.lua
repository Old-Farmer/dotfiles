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

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- NOTE: lazy.nvim read files in the alphabetical order

    -- General plugins
    { import = "plugins" },
    -- Languages specific
    { import = "plugins.languages" },
  },
  defaults = {
    lazy = true, -- Lazy-load by default
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  checker = {
    enabled = true, -- check for plugin updates periodically
    notify = false, -- notify on update
  }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- Close Lazy floating window when unfocused
vim.api.nvim_create_augroup("lazy_user", { clear = true })
vim.api.nvim_create_autocmd("BufLeave", {
  group = "lazy_user",
  callback = function()
    local ft = vim.api.nvim_get_option_value("filetype", { buf = vim.api.nvim_get_current_buf() })
    if ft == "lazy" then
      require("lazy.view").view:close()
    end
  end,
})
