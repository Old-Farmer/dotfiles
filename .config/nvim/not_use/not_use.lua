-- Interesting root detection
-- I think neovim need workspace concept integration like vscode, not heuristic detect root
-- [1] : {key = {value = any, order = number}}
-- queue: [key]
local root_cache = { kvs = {}, queue = {}, max_cnt = 256 }

-- LRU cache implementation
-- TODO: Refact to use OOP

local function get_cache(cache, key)
  local v = cache.kvs[key]
  if v then
    if v.order ~= 1 then
      table.remove(cache.queue, v.order)
      table.insert(cache.queue, 1, key)
    end
    return v.value
  end
  return nil
end

local function set_cache(cache, key, value)
  if vim.tbl_count(cache.kvs) == cache.max_cnt then
    cache.kvs[cache.queue[1]] = nil
    table.remove(cache.queue, 1)
  end

  cache.kvs[key] = { value = value, order = 1 }
  table.insert(cache.queue, 1, key)
end

-- Root path
function M.root()
  local bufnr = vim.api.nvim_get_current_buf()

  local root = nil

  -- Try cache
  root = get_cache(root_cache, bufnr)
  if root then
    return root
  end

  -- -- Try lsp workspace folders
  -- local workspace_folders = vim.lsp.buf.list_workspace_folders()
  -- if #workspace_folders ~= 0 then
  --   root = workspace_folders[1]
  --   set_cache(root_cache, bufnr, root)
  --   return root
  -- end

  -- Try lsp root_dir
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  if #clients ~= 0 then
    root = clients[1].config.root_dir
    set_cache(root_cache, bufnr, root)
    return root
  end

  local buffer_path = vim.api.nvim_buf_get_name(bufnr)
  -- No name? cwd !
  if buffer_path ~= "" then
    return vim.uv.cwd()
  end

  -- Try all lsp clients
  for _, client in ipairs(vim.lsp.get_clients()) do
    if string.find(buffer_path, client.root_dir, 1, true) ~= nil then
      root = client.root_dir
      set_cache(root_cache, bufnr, root)
      return root
    end
  end

  -- Try other things
  root = vim.fs.root(0, function(name, path)
    -- full match
    if name == ".git" or name == "lua" or (name == "Makefile" and path:find("build") == nil) then
      return true
    elseif name:match("%.clang.+") then
      return true
    end
    return false
  end)
  if root then
    set_cache(root_cache, bufnr, root)
    return root
  end

  -- Now only return cwd
  return vim.uv.cwd()
end



-- some key specs

      -- {
      --   "<leader>e",
      --   function()
      --     require("nvim-tree.api").tree.toggle({ path = Easynvim.root() })
      --   end,
      --   desc = "Explorer (root) toggle",
      -- },
      -- {
      --   "<leader>E",
      --   function()
      --     require("nvim-tree.api").tree.toggle({ path = vim.uv.cwd() })
      --   end,
      --   desc = "Explorer(cwd) toggle",
      -- },

      -- {
      --   "<leader>sf",
      --   function()
      --     require("telescope.builtin").find_files({ cwd = Easynvim.root() })
      --   end,
      --   desc = "Search files (root)",
      -- },
      -- {
      --   "<leader>sF",
      --   function()
      --     require("telescope.builtin").find_files({ cwd = vim.uv.cwd() })
      --   end,
      --   desc = "Search files (cwd)",
      -- },
      -- {
      --   "<leader>sf",
      --   function()
      --     require("telescope.builtin").live_grep({ cwd = Easynvim.root() })
      --   end,
      --   desc = "Search by grep (root)",
      -- },
      -- {
      --   "<leader>sG",
      --   function()
      --     require("telescope.builtin").live_grep({ cwd = vim.uv.cwd() })
      --   end,
      --   desc = "Search by grep (cwd)",
      -- },


      -- {
      --   "<leader>tf",
      --   function()
      --     require("toggleterm").toggle(vim.v.count, nil, Easynvim.root(), "float")
      --   end,
      --   desc = "Terminal (Float, root) toggle",
      -- },
      -- {
      --   "<leader>tF",
      --   function()
      --     require("toggleterm").toggle(vim.count, nil, vim.uv.cwd(), "float")
      --   end,
      --   desc = "Terminal (Float, cwd) toggle",
      -- },
      -- {
      --   "<leader>th",
      --   function()
      --     require("toggleterm").toggle(vim.v.count, nil, Easynvim.root(), "horizontal")
      --   end,
      --   desc = "Terminal (Horizontal, root) toggle",
      -- },
      -- {
      --   "<leader>tH",
      --   function()
      --     require("toggleterm").toggle(vim.v.count, nil, vim.uv.cwd(), "horizontal")
      --   end,
      --   desc = "Terminal (Horizontal, cwd) toggle",
      -- },
      -- {
      --   "<leader>tv",
      --   function()
      --     require("toggleterm").toggle(vim.v.count, nil, Easynvim.root(), "vertical")
      --   end,
      --   desc = "Terminal (Vertical, root) toggle",
      -- },
      -- {
      --   "<leader>tV",
      --   function()
      --     require("toggleterm").toggle(vim.v.count, nil, vim.uv.cwd(), "vertical")
      --   end,
      --   desc = "Terminal (Vertical, cwd) toggle",
      -- },
      -- {
      --   "<leader>tt",
      --   function()
      --     require("toggleterm").toggle(vim.v.count, nil, Easynvim.root(), "tab")
      --   end,
      --   desc = "Terminal (Tab, root) toggle",
      -- },
      -- {
      --   "<leader>tT",
      --   function()
      --     require("toggleterm").toggle(vim.v.count, nil, vim.uv.cwd(), "tab")
      --   end,
      --   desc = "Terminal (Tab, cwd) toggle",
      -- },

-- terminal
-- key: path, value: toggleterm terminal
local eazynvim_terminals = {} -- Special terminals
local cur_etid = -1 -- Use id < 1
local visible_term = nil -- visible EazyNvim Terminal

-- cmd?
local function eazynvim_terminal_toggle(cmd)
  if visible_term then
    visible_term:toggle()
    return
  end

  local path = vim.uv.cwd()
  if not path then
    return
  end

  visible_term = eazynvim_terminals[path]
  if visible_term then
    visible_term:toggle()
  else
    require("toggleterm.terminal").Terminal
      :new({
        display_name = "EazyNvim Terminal(cwd: " .. Easynvim.path_truncate(path, 2) .. ")",
        cmd = cmd,
        count = cur_etid,
        dir = path,
        direction = "float",
        on_create = function(term)
          eazynvim_terminals[path] = term
        end,
        on_open = function(term)
          visible_term = term
        end,
        on_close = function()
          visible_term = nil
        end,
        on_exit = function()
          eazynvim_terminals[path] = nil
        end,
        hidden = true, -- Will not toggle by command
      })
      :toggle()
    cur_etid = cur_etid - 1
  end
end

local function eazynvim_terminal_select()
  if vim.tbl_isempty(eazynvim_terminals) then
    vim.schedule(function()
      vim.notify("No EazyNvim Terminal has been opened!", nil, { title = "EazyNvim" })
    end)
    return
  end

  local all_terms = vim.tbl_values(eazynvim_terminals)
  vim.ui.select(all_terms, {
    prompt = "Select a EazyNvim Terminal",
    format_item = function(item)
      return item.count .. ": " .. item.display_name
    end,
  }, function(choice)
    if not choice then
      return
    end

    -- Seems not possible, so I comment it
    -- -- First shut down any visible eazynvim terminal
    -- if visible_term then
    --   print("Any visible terminal remaining")
    --   visible_term:toggle()
    -- end
    choice:toggle()
  end)
end


-- terminal key spec
      -- -- Toggle a special terminal that
      -- {
      --   "<c-/>",
      --   eazynvim_terminal_toggle,
      --   desc = "Easynvim Terminal toggle",
      --   mode = { "n", "t" },
      -- },
      --
      -- {
      --   "<leader>tS",
      --   eazynvim_terminal_select,
      --   desc = "Easynvim Terminal select",
      -- },



      -- {
      --   "<leader>tf",
      --   function()
      --     require("toggleterm").toggle(vim.v.count, nil, Easynvim.workspace(), "float")
      --   end,
      --   desc = "Terminal (float, workspace) toggle",
      -- },
      -- {
      --   "<leader>th",
      --   function()
      --     require("toggleterm").toggle(vim.v.count, nil, Easynvim.workspace(), "horizontal")
      --   end,
      --   desc = "Terminal (horizontal, workspace) toggle",
      -- },
      -- {
      --   "<leader>tv",
      --   function()
      --     require("toggleterm").toggle(vim.v.count, nil, Easynvim.workspace(), "vertical")
      --   end,
      --   desc = "Terminal (vertical, workspace) toggle",
      -- },
      -- {
      --   "<leader>tt",
      --   function()
      --     require("toggleterm").toggle(vim.v.count, nil, Easynvim.workspace(), "tab")
      --   end,
      --   desc = "Terminal (tab, workspace) toggle",
      -- },


-- workspace
map("n", "<leader>k", function()
  Easynvim.workspace_ = Easynvim.root()
  vim.uv.chdir(Easynvim.workspace_)
  vim.notify("Workspace: " .. Easynvim.workspace_ .. "\n\nCwd: " .. vim.uv.cwd(), nil, { title = "EazyNvim" })
end, { desc = "Detect workspace" })
map("n", "<leader>K", function()
  Easynvim.workspace_ = Easynvim.root()
  vim.notify("Workspace: " .. Easynvim.workspace_, nil, { title = "EazyNvim" })
end, { desc = "Detect workspace (not cd)" })


-- Set pwd to Root
command("CdRoot", function()
  local root = Easynvim.root()
  vim.cmd("cd" .. root)
  vim.notify("Cd to " .. root)
end, {})


-- ## Something special && interesting
--
-- When I use LazyVim, the root dir detection is frequently triggered based on the default mappings, which I think is not really necessary. So I treat EasyNvim.workspace as a workspace directory variable, make root detection manually triggered.
--
-- - Use <leader>k / <leader>K to switch to workspace dir(root dir)
-- - <c-/> can toggle a special floating terminal based on workspace, use <leader>tS to manage them
