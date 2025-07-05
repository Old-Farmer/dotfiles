-- General keymaps
-- Plugin keymaps are not set here

local map = vim.keymap.set

-- Better up/down, I don't want to set <up> <down> because I never use them
-- x means visual mode
map({ "n", "x" }, "j", function()
  return vim.count == 0 and "gj" or "j"
end, { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", function()
  return vim.count == 0 and "gk" or "k"
end, { desc = "Up", expr = true, silent = true })

-- Nohlsearch
map("n", "<esc>", "<cmd>nohlsearch<cr>", { desc = "No highlight search" })

-- Save file
map("n", "<leader>w", "<cmd>write<cr><esc>", { desc = "Save file" })

-- Resize windows
map("n", "<c-up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<c-down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<c-left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<c-right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Exit terminal mode
map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Exit terminal mode" })

-- Navigate through terminal windows
map("t", "<c-h>", "<cmd>wincmd h<cr>", { desc = "Go to the left window" })
map("t", "<c-j>", "<cmd>wincmd j<cr>", { desc = "Go to the lower window" })
map("t", "<c-k>", "<cmd>wincmd k<cr>", { desc = "Go to the upper window" })
map("t", "<c-l>", "<cmd>wincmd l<cr>", { desc = "Go to the right window" })

-- Diagnostic
map("n", "<leader>xl", vim.diagnostic.setloclist, { desc = "Location list" })
map("n", "<leader>xq", vim.diagnostic.setqflist, { desc = "Quickfix list" })

-- Buffer
map("n", "<leader>bD", "<cmd>bdelete<cr>", { desc = "Delete buffer and window" })
map("n", "<s-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<s-h>", "<cmd>bnext<cr>", { desc = "Prev buffer" })

-- Quit all
map("n", "<leader>qq", "<cmd>quitall<cr>", { desc = "Quit all" })
