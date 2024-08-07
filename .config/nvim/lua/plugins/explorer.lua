return {
  {
    "nvim-tree/nvim-tree.lua",
    lazy = false, -- Lazy load file tree plugin is not that worthy
    keys = {
      {
        "<leader>e",
        "<cmd>NvimTreeToggle<cr>",
        desc = "Explorer toggle",
      },
      {
        "<leader>fe",
        function()
          require("nvim-tree.api").tree.toggle({ path = vim.uv.cwd() })
        end,
        desc = "Explorer toggle (cwd)",
      },
    },
    opts = function()
      local diagnostic_icons = vim.diagnostic.config().signs.text
      return {
        -- actions = {
        --   change_dir = {
        --     enable = false,
        --   },
        -- },
        -- diagnostic is not always shown, so not enable it
        diagnostics = {
          enable = true,
          debounce_delay = 200,
          icons = {
            ---@diagnostic disable-next-line: need-check-nil
            error = diagnostic_icons[1],
            ---@diagnostic disable-next-line: need-check-nil
            warning = diagnostic_icons[2],
            ---@diagnostic disable-next-line: need-check-nil
            info = diagnostic_icons[3],
            ---@diagnostic disable-next-line: need-check-nil
            hint = diagnostic_icons[4],
          },
        },
        filters = {
          enable = false,
        },
        renderer = {
          group_empty = true,
          highlight_hidden = "all",
          indent_markers = {
            enable = true,
          },
        },
        -- respect_buf_cwd = true,
        -- sync_root_with_cwd = true,
        update_focused_file = {
          enable = true,
          -- update_root = true,
        },
        view = {
          width = 30,
        },
      }
    end,
  },
}
