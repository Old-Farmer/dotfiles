local function gh(path)
  return "https://github.com/" .. path
end

vim.pack.add({
  gh("nvim-lua/plenary.nvim"), -- dependency
  gh("nvim-telescope/telescope-fzf-native.nvim"), -- dependency
  gh("nvim-telescope/telescope.nvim"),

  gh("ibhagwan/fzf-lua"),
})


local pack_changed = function(ev)
  local name, kind = ev.data.spec.name, ev.data.kind

  -- if name == "telescope-fzf-native.nvim" and (kind == "install" or kind == "update") then
  --   vim.system({ "make" }, { cwd = ev.data.path }):wait()
  -- end
end

vim.api.nvim_create_autocmd("PackChanged", { callback = pack_changed })

require("telescope").setup({
  -- file_ignore_patterns = {
  -- 	"build.*/",
  -- },
})
require("telescope").load_extension("fzf")
vim.cmd([[
nmap <leader><space> <cmd>Telescope find_files<cr>
nmap <leader>, <cmd>Telescope buffers<cr>
nmap <leader>sg <cmd>Telescope live_grep<cr>
]])

-- fuzzy finder
require("fzf-lua").setup({
  winopts = {
    backdrop = 100,
    preview = {
      hidden = true,
    },
  },
  -- An insteresting fallback mechanism. Not use now.
  -- actions = {
  --   buffers = {
  --     ["enter"] = function(selected, opts)
  --       if #selected == 0 then
  --         require("fzf-lua").files()
  --       else
  --         require("fzf-lua.actions").buf_edit(selected, opts)
  --       end
  --     end,
  --   },
  -- },
  files = {
    find_opts = [[-type f \! -path '*/.git/*' \( -path build -o -path .cache \) -prune]],
    rg_opts = [[--color=never --hidden --files -g "!.git" -g "!build" -g "!.cache"]],
    fd_opts = [[--color=never --hidden --type f --type l --exclude .git --exclude build --exclude .cache]],
  },
})
vim.cmd([[
nmap <leader><leader> <cmd>FzfLua buffers<cr>
nmap <leader>sf <cmd>FzfLua files<cr>
nmap <leader>sr <cmd>FzfLua resume<cr>
]])
