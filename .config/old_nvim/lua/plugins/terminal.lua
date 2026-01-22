return {
  {
    "akinsho/toggleterm.nvim",
    cmd = {
      "ToggleTerm",
      "ToggleTermToggleAll",
      "TermExec",
      "TermSelect",
      "ToggleTermSetName",
    },
    keys = {
      { "<leader>ta", "<cmd>ToggleTermToggleAll<cr>", desc = "All Terminals" },
      { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Terminal (float) toggle" },
      { "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Terminal (horizontal) toggle" },
      { "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>", desc = "Terminal (vertical) toggle" },
      { "<leader>tt", "<cmd>ToggleTerm direction=tab<cr>", desc = "Terminal (tab) toggle" },
      { "<C-_>" },
      { "<leader>tn", "<cmd>ToggleTermSetName<cr>", desc = "Set terminal name" },
      { "<leader>ts", "<cmd>TermSelect<cr>", desc = "Select terminals" },
    },
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return 12
        elseif term.direction == "vertical" then
          return math.floor(vim.o.columns * 0.4)
        end
      end,
      open_mapping = "<C-_>",
      direction = "float",
      -- shade_terminals = false,
      float_opts = {
        border = "curved",
        -- border = "shadow",
        title_pos = "right",
        width = function()
          return math.floor(vim.o.columns * 0.95)
        end,
        height = function()
          return math.floor(vim.o.lines * 0.85)
        end,
      },
    },
  },
}
