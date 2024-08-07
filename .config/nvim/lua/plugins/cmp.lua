return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    opts = function()
      local cmp = require("cmp")

      return {
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
            -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
          end,
        },
        -- preselect
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        preselect = cmp.PreselectMode.Item,

        window = {
          -- completion = cmp.config.window.bordered(),
          -- documentation = cmp.config.window.bordered(),
        },

        -- Disable auto open docs
        view = {
          docs = { auto_open = false },
        },

        mapping = cmp.mapping.preset.insert({
          ["<tab>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
          ["<s-tab>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
          ["<c-d>"] = cmp.mapping.scroll_docs(-4),
          ["<c-f>"] = cmp.mapping.scroll_docs(4),
          ["<c-space>"] = cmp.mapping.complete(),
          ["<cr>"] = cmp.mapping.confirm({ select = true }),
          ["<s-cr>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<c-cr>"] = function(fallback)
            cmp.abort()
            fallback()
          end,
          -- Toggle docs view
          ["<c-g>"] = function(fallback)
            if cmp.visible() then
              if cmp.visible_docs() then
                cmp.close_docs()
              else
                cmp.open_docs()
              end
            else
              fallback()
            end
          end,
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" }, -- For luasnip users.
          { name = "path" },
        }, {
          { name = "buffer" },
        }),
        sorting = require("cmp.config.default")().sorting,
      }
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    -- stylua: ignore
    keys = {
      {
        "<tab>",
        function()
          return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
        end,
        expr = true, silent = true, mode = "i",
      },
      { "<tab>", function() require("luasnip").jump(1) end, mode = "s" },
      { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
    },
    opts = function()
      -- Set user snippets loc, default is nvim config path
      require("luasnip.loaders.from_vscode").lazy_load()

      return {
        history = false,
        region_check_events = "InsertEnter",
      }
    end,
  },
  { -- optional completion source for require statements and module annotations
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, {
        name = "lazydev",
        group_index = 0, -- set group index to 0 to skip loading LuaLS completions
      })
    end,
  },
}
