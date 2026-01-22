if not Global_config.languages.c_cpp then
  return {}
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "cpp" } },
  },
  {
    "p00f/clangd_extensions.nvim",
    ft = { "c", "cpp" },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          keymaps = {
            { "<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch source/header (C/C++)" },
          },
          cmd = {
            "clangd",
            "--header-insertion=never",
            "--query-driver=/usr/bin/cc,/usr/bin/c++,/usr/bin/gcc*,/usr/bin/g++*,/usr/bin/clang*,/usr/bin/clang++*",
            "--pretty",
            "--background-index",
            "--clang-tidy",
            "--completion-style=detailed",
            "--fallback-style=google",
          },
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
          },
        },
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      table.insert(opts.sorting.comparators, 1, require("clangd_extensions.cmp_scores"))
    end,
  },
}
