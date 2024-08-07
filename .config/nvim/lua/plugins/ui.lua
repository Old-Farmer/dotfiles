return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      spec = {
        mode = { "n", "v" },
        {
          "<leader>b",
          group = "+buffer",
          -- expand = function()
          -- 	return require("which-key.extras").expand.buffer()
          -- end,
        },
        { "<leader>c", group = "+code" },
        { "<leader>f", group = "+file" },
        { "<leader>g", group = "+git" },
        { "<leader>q", group = "+quit/session" },
        { "<leader>s", group = "+search" },
        {
          "<leader>w",
          group = "+window",
          proxy = "<c-w>",
          -- expand = function()
          -- 	return require("which-key.extras").expand.win()
          -- end,
        },
        { "<leader>t", group = "+terminal" },
        { "<leader>u", group = "+ui" },
        { "<leader>x", group = "+diagnostic" },
        { "<leader><tab>", group = "+tab" },
      },
      triggers = {
        { "<auto>", mode = "nxso" },
      },
      icons = {
        mappings = false, -- Disable icons now because some keymaps cannot show icons automatically
        keys = {
          Up = "<Up>",
          Down = "<Down>",
          Left = "<Left>",
          Right = "<Right>",
          C = "C-",
          M = "A-",
          D = "D-",
          S = "S-",
          CR = "<Enter>",
          Esc = "<Esc>",
          ScrollWheelDown = "<ScrollWheelDown>",
          ScrollWheelUp = "<ScrollWheelUp>",
          NL = "<NL>",
          BS = "<BS>",
          Space = "<Space>",
          Tab = "<Tab>",
          F1 = "<F1>",
          F2 = "<F2>",
          F3 = "<F3>",
          F4 = "<F4>",
          F5 = "<F5>",
          F6 = "<F6>",
          F7 = "<F7>",
          F8 = "<F8>",
          F9 = "<F9>",
          F10 = "<F10>",
          F11 = "<F11>",
          F12 = "<F12>",
        },
      },
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
  -- -- Extensible UI for Neovim notifications and LSP progress messages.
  -- {
  --   "j-hui/fidget.nvim",
  --   event = "VeryLazy",
  --   opts = {
  --     notification = {
  --       override_vim_notify = true,
  --     },
  --   },
  -- },
  -- Excellent UI plugin
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false, -- add a border to hover docs and signature help
      },
    },
    -- Ref LazyVim
    config = function(_, opts)
      -- HACK: noice shows messages from before it was enabled,
      -- but this is not ideal when Lazy is installing plugins,
      -- so clear the messages in this case.
      if vim.o.filetype == "lazy" then
        vim.cmd([[messages clear]])
      end
      require("noice").setup(opts)
    end,

    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    },
  },
  {
    "rcarriga/nvim-notify",
    opts = {
      stages = "static",
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      on_open = function(win)
        vim.api.nvim_win_set_config(win, { zindex = 100 })
      end,
    },
  },
  {
    "akinsho/bufferline.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    event = "VeryLazy",
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
      { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete other buffers" },
      { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete buffers to the right" },
      { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete buffers to the left" },
      { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
      { "<s-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
      { "<s-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
      { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
    },
    opts = {
      -- catppuccin integration
      highlights = require("catppuccin.groups.integrations.bufferline").get(),
      options = {
        close_command = function(n)
          require("bufdelete").bufdelete(n)
        end,
        right_mouse_command = function(n)
          require("bufdelete").bufdelete(n)
        end,
        offsets = {
          {
            filetype = "NvimTree",
            text = "Explorer",
            text_align = "left",
            separator = true,
            highlight = "Directory",
          },
        },
        always_show_bufferline = false,
        diagnostics = "nvim_lsp",
      },
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    main = "ibl",
    opts = {
      indent = {
        tab_char = "│",
      },
      scope = {
        show_start = false,
        show_end = false,
      },
      exclude = {
        filetypes = {
          "help",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
        },
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      local recording_reg = function()
        local reg = vim.fn.reg_recording()
        if reg == "" then
          return ""
        else
          return "recording @" .. reg
        end
      end

      local workspace = function()
        -- alternative icon: 
        return "  " .. Easynvim.path_truncate(vim.uv.cwd(), 2)
      end

      return {
        options = {
          theme = "catppuccin",
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = {
            workspace,
            "filename",
          },
          lualine_x = {
            -- just add recording @'reg'
            recording_reg,
            "encoding",
            "fileformat",
            "filetype",
          },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      }
    end,
    config = function(_, opts)
      local lualine = require("lualine")
      lualine.setup(opts)

      local lualine_statusline_refresh = function()
        lualine.refresh({ place = { "statusline" } })
      end

      local group = vim.api.nvim_create_augroup("eazynvim_record", { clear = true })
      vim.api.nvim_create_autocmd("RecordingEnter", {
        group = group,
        callback = lualine_statusline_refresh,
      })
      vim.api.nvim_create_autocmd("RecordingLeave", {
        group = group,
        callback = function()
          -- When just leaving, reg_recording is not updated, so wait for 50ms then refresh
          vim.uv.new_timer():start(50, 0, vim.schedule_wrap(lualine_statusline_refresh))
        end,
      })
    end,
  },
  -- To dim inactive windows
  -- {
  --   "levouh/tint.nvim",
  --   event = "VeryLazy",
  --   opts = {}
  -- },
}
