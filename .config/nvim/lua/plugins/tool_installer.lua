return {
  {
    -- Ref LazyVim mason config
    "mason-org/mason.nvim",
    -- mason.nvim is optimized to load as little as possible during setup.
    -- Lazy-loading the plugin, or somehow deferring the setup, is not recommended.
    lazy = false,
    opts = {
      ensure_installed = {
        "stylua",
        "shfmt",
        "tree-sitter-cli",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr.refresh(function()
        for _, pkg in ipairs(opts.ensure_installed) do
          if not mr.is_installed(pkg) then
            vim.cmd("MasonInstall " .. pkg)
          end
        end
      end)
    end,
  },
}
