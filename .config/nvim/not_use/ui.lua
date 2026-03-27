  -- { src = gh("catppuccin/nvim"), name = "catppuccin" },

-- ui
-- require("catppuccin").setup({
--   custom_highlights = function(colors)
--     return {
--       ["@lsp.typemod.variable.readonly"] = { link = "Constant" },
--       ["@property"] = { fg = colors.text },
--     }
--   end,
-- })
-- vim.cmd([[
-- colorscheme catppuccin
-- ]])
-- vim.g.zenbones_compat = 1


require("tokyonight").setup({
  style = "night",
  on_colors = function(colors)
    -- colors.yellow = "#ffd088"
    -- colors.orange = "#eb8a58"
    -- colors.orange = "#fca7ea"
    -- colors.orange = "#FF8D47"

    colors.yellow = "#f6d06f"
    -- colors.yellow = "#d8b04c"
    colors.orange = "#ff8f40"
    colors.green = "#8fc85e"
  end,
  on_highlights = function(hl, c)
    hl["@lsp.typemod.variable.static"] = { link = "@variable" }
    -- hl["@lsp.type.parameter"] = { fg = c.fg, bold = true }
  end,
})
