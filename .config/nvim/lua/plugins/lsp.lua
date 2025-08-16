return {
  {
    "neovim/nvim-lspconfig",
    -- See https://github.com/LazyVim/LazyVim/discussions/1583
    -- See https://www.reddit.com/r/neovim/comments/1l7pz1l/starting_from_0112_i_have_a_weird_issue/
    event = { "BufReadPre", "BufWritePre", "BufNewFile" },
    opts = {
      -- Lsp keymaps
      keymaps = {
        { "gd", "<cmd>Telescope lsp_definitions<cr>", desc = "Goto definition" },
        { "gD", vim.lsp.buf.declaration, desc = "Goto declaration" },
        { "grr", "<cmd>Telescope lsp_references<cr>", desc = "Goto references" },
        { "gri", "<cmd>Telescope lsp_implementations<cr>", desc = "Goto implementation" },
        { "grt", "<cmd>Telescope lsp_type_definitions<cr>", desc = "Goto type definition" },
        { "<leader>ss", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Search document symbols" },
        { "<leader>sS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Search workspace symbols" },
        toggle_inlay_hints = {
          "<leader>uh",
          function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
          end,
          desc = "Toggle inlay hints",
        },
      },
      -- Inlay hints
      inlay_hints = {
        enabled = true,
      },
      -- Codelens
      codelens = {
        enabled = false,
      },
      -- Lsp cursor word highlighting
      document_highlight = {
        enabled = true,
      },
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      -- Enable the following language servers
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      servers = {
        -- See `:help lspconfig-all` for a list of all the pre-configured LSPs
        lua_ls = {
          -- cmd = {...},
          -- filetypes = { ...},
          -- capabilities = {},
          -- keymaps = {} -- Additional keymaps, not nvim_lspconfig options
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              codeLens = {
                enable = true,
              },
              completion = {
                callSnippet = "Replace",
              },
              doc = {
                privateName = { "^_" },
              },
              hint = {
                enable = true,
                setType = false,
                paramType = true,
                paramName = "Disable",
                semicolon = "Disable",
                arrayIndex = "Disable",
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      },
      -- Like LazyVim, additional setup can be set.
      -- Return true if don't want config server using nvim-lspconfig
      setups = {},
    },
    config = function(_, opts)
      -- Process keymaps
      for _, keymap in pairs(opts.keymaps) do
        Easynvim.process_keymap(keymap)
      end
      for _, server in pairs(opts.servers) do
        if server.keymaps then
          for _, keymap in pairs(server.keymaps) do
            Easynvim.process_keymap(keymap)
          end
        end
      end

      local easynvim_lspattach = vim.api.nvim_create_augroup("easynvim_lspattch", { clear = true })
      vim.api.nvim_create_autocmd("LspAttach", {
        group = easynvim_lspattach,
        callback = function(args)
          -- A help function to map lsp mappings
          local function lsp_map(keymap)
            local keymap_opts = keymap[4]
            keymap_opts.buffer = args.buf
            vim.keymap.set(keymap[1], keymap[2], keymap[3], keymap[4])
          end

          -- Map general lsp keymaps
          -- We reuse opts.keymap
          for _, keymap in ipairs(opts.keymaps) do
            lsp_map(keymap)
          end

          -- Default, we have:
          -- K, etc.
          -- See ":h default-mappings"

          local client = vim.lsp.get_client_by_id(args.data.client_id)

          if not client then
            return
          end

          -- Map specific lsp keymaps
          local specific_lsp_keymaps = opts.servers[client.config.name].keymaps
          if specific_lsp_keymaps then
            for _, keymap in pairs(specific_lsp_keymaps) do
              lsp_map(keymap)
            end
          end

          -- Document highlight
          if
            opts.document_highlight.enabled
            and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight)
          then
            local highlight_augroup = vim.api.nvim_create_augroup("easynvim_lsp_highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = args.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = args.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
              group = vim.api.nvim_create_augroup("easynvim_lsp_detach", { clear = true }),
              callback = function(args2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = "easynvim_lsp_highlight", buffer = args2.buf })
              end,
            })
          end

          -- Codelens
          if opts.codelens.enabled and client:supports_method(vim.lsp.protocol.Methods.textDocument_codeLens) then
            vim.lsp.codelens.refresh()
            vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
              buffer = args.buf,
              callback = vim.lsp.codelens.refresh,
            })
          end

          -- Inlay hints & toggle inlay hints keymap
          if opts.inlay_hints.enabled and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            vim.lsp.inlay_hint.enable(true, { bufnr = 0 }) -- Enable inlay hint of the current buffer
            lsp_map(opts.keymaps.toggle_inlay_hints) -- map toggle_inlay_hints
          end
        end,
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      vim.lsp.config("*", { capabilities = require("cmp_nvim_lsp").default_capabilities() })

      local servers = opts.servers
      local setups = opts.setups
      local ensure_installed = vim.tbl_keys(servers)

      -- config
      for server_name, server in pairs(servers) do
        -- Skip setup server if additional setup return true
        if setups[server_name] and setups[server_name]() then
          return
        end

        if server.keymaps then
          server.keymaps = nil
        end
        vim.lsp.config(server_name, server)
      end

      -- Setup mason-lspconfig here.
      -- Means to install some language servers and setup lsp
      require("mason-lspconfig").setup({
        ensure_installed = ensure_installed, -- ensure install servers
      })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    -- Will call setup in nvim-lspconfig
  },
  -- Lua lsp
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  { "Bilal2453/luvit-meta" }, -- optional `vim.uv` typings
}
