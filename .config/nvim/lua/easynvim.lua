local M = {}

-- ref by https://gist.github.com/LunarLambda/4c444238fb364509b72cfb891979f1dd
-- Set indentaion
function M.set_indentation(scope, style, n)
  local opt = vim.opt
  if scope == "global" then
    opt = vim.opt_global
  elseif scope == "local" then
    opt = vim.opt_local
  end

  if style == "tab" then
    opt.expandtab = false
    opt.tabstop = n
    opt.shiftwidth = 0
    opt.softtabstop = 0
    opt.smarttab = true
  elseif style == "spaces" then
    opt.expandtab = true
    opt.tabstop = n
    opt.shiftwidth = n
    opt.softtabstop = -1
    opt.smarttab = true
  else -- mixed
    vim.cmd([[ set tabstop& ]])
    opt.expandtab = false
    opt.shiftwidth = n
    opt.softtabstop = -1
    opt.smarttab = true
  end
end

-- Truncate path to last n parts
-- Make sure tha path has been normalized
function M.path_truncate(path, n)
  path = string.gsub(path, vim.env.HOME, "~")
  local sub_path = vim.split(path, "/", { trimempty = true })
  if #sub_path <= n then
    return path
  elseif #sub_path == n and sub_path[1] == "~" then
    return path
  else
    local ret = "..."
    for i = #sub_path - (n - 1), #sub_path do
      ret = ret .. "/" .. sub_path[i]
    end
    return ret
  end
end

-- Modify a keymap table(lazy.nvim plugin keyspec style) to the style can pass to vim.keymap.set
-- Deep copy it if you do not want to modify the origin table
function M.process_keymap(keymap)
  local mode = keymap.mode
  if mode == nil then
    mode = "n"
  end
  table.insert(keymap, 1, "n")

  local keymap_opts = {}
  for k, v in pairs(keymap) do
    if type(k) ~= "number" then
      keymap_opts[k] = v
      keymap[k] = nil
    end
  end
  keymap[#keymap + 1] = keymap_opts
end

return M
