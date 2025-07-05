-- General autocmds

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("highlight_on_yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Make '_' not a key word
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = "*",
  command = "setlocal iskeyword-=_",
  desc = "Set iskeyword",
})

-- Indentation for FileType
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "lua", "cmake", "markdown", "sshconfig" },
  callback = function()
    Easynvim.set_indentation("local", "spaces", 2)
  end,
  desc = "Set indentation for some ft",
})

-- Wrap for FileType
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "markdown" },
  callback = function()
    vim.opt_local.wrap = true
  end,
  desc = "Set wrap for some ft",
})
