return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 2000,
    opts = {
      -- dim_inactive = {
      --   enabled = true,
      -- },
      integrations = {
        cmp = true,
        -- fidget = true,
        gitsigns = true,
        indent_blankline = { enabled = true },
        lsp_trouble = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
          -- inlay_hints = {
          --   background = true,
          -- },
        },
        noice = true,
        telescope = true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd("colorscheme catppuccin")
    end,
  },
}
