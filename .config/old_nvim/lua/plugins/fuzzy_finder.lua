return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "<leader>sa", "<cmd>Telescope autocmds<cr>", desc = "Search autocmds" },
      { "<leader>,", "<cmd>Telescope buffers<cr>", desc = "Search buffers" },
      { "<leader>sb", "<cmd>Telescope buffers<cr>", desc = "Search buffers" },
      { "<leader>sB", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Search in the current buffer" },
      {
        "<leader>sc",
        function()
          require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
        end,
        desc = "Search config files",
      },
      {
        "<leader>sf",
        "<cmd>Telescope find_files<cr>",
        desc = "Search files",
      },
      {
        "<leader><space>",
        "<cmd>Telescope find_files<cr>",
        desc = "Search files",
      },
      {
        "<leader>sg",
        "<cmd>Telescope live_grep<cr>",
        desc = "Search by grep",
      },
      {
        "<leader>sh",
        function()
          require("telescope.builtin").find_files({ cwd = vim.env.HOME })
        end,
        desc = "Search files in home dir",
      },
      { "<leader>sH", "<cmd>Telescope help_tags<cr>", desc = "Search helps" },
      { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Search keymaps" },
      { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Search marks" },
      { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Search man pages" },
      { "<leader>so", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Search symbols" },
      { "<leader>sr", "<cmd>Telescope registers<cr>", desc = "Search registers" },
    },
    config = function()
      local telescope = require("telescope")
      telescope.load_extension("fzf")
    end,
  },
  -- Perf
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make", -- Assume that make exists
  },
  -- Better vim.ui
  {
    "stevearc/dressing.nvim",
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },
}
