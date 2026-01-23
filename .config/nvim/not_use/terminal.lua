local function gh(path)
  return "https://github.com/" .. path
end
vim.pack.add({
  gh("akinsho/toggleterm.nvim"),
})

-- terminal
require("toggleterm").setup({
  size = function(term)
    if term.direction == "horizontal" then
      return 12
    elseif term.direction == "vertical" then
      return math.floor(vim.o.columns * 0.4)
    end
  end,
  open_mapping = "<C-_>",
  direction = "float",
  float_opts = {
    border = "curved",
    title_pos = "right",
    width = function()
      return math.floor(vim.o.columns * 0.95)
    end,
    height = function()
      return math.floor(vim.o.lines * 0.85)
    end,
  },
})
vim.cmd([[
nmap <leader>tf <cmd>ToggleTerm direction=float<cr>
nmap <leader>th <cmd>ToggleTerm direction=horizontal<cr>
nmap <leader>tv <cmd>ToggleTerm direction=vertical<cr>
nmap <leader>ts <cmd>TermSelect<cr>
]])
