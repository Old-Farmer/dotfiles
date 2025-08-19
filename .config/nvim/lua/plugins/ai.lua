return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    lazy = false,
    enabled = false, -- buggy, diabled it
    opts = {},
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    build = "make tiktoken",
    keys = {
      {
        "<leader>i",
        "<cmd>CopilotChatToggle<cr>",
        desc = "Copilot Chat toggle",
      },
    },
    opts = {
      model = "gpt-4.1", -- AI model to use
      temperature = 0.1, -- Lower = focused, higher = creative
      window = {
        layout = "vertical", -- 'vertical', 'horizontal', 'float'
        width = 0.3, -- 30% of screen width
      },
      auto_insert_mode = true, -- Enter insert mode when opening
      headers = {
        user = "👤 You: ",
        assistant = "🤖 Copilot: ",
        tool = "🔧 Tool: ",
      },
      separator = "━━",
      show_folds = false, -- Disable folding for cleaner look
    },
  },
  -- {
  --   "github/copilot.vim",
  --   lazy = false,
  --   enabled = false,
  --   init = function ()
  --     vim.g.copilot_assume_mapped = true
  --   end
  -- },
}
