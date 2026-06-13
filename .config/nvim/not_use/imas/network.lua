local M = {}

--- @param host string
--- @param port integer
--- @return vim.uv.uv_tcp_t
function M.create_client(host, port)
  local client = vim.uv.new_tcp()
  assert(client ~= nil, "new_tcp error")
  client:nodelay(true)
  client:connect(host, port, function(err)
    assert(err == nil, err)
    vim.print(string.format("im-autoswitch: client connected to %s:%d", host, port))
  end)
  return client
end

--- @param host string
--- @param port integer
--- @param mode {} opts.mode
--- @return vim.uv.uv_tcp_t
function M.create_server(host, port)
  local msg_to_func = {
    ["i"] = function()
      require("imas").im_enter("insert", 0, true)
    end,
    ["I"] = function()
      require("imas").im_leave("insert", 0, true)
    end,
    ["c"] = function()
      require("imas").im_enter("cmdline", 0, true)
    end,
    ["C"] = function()
      require("imas").im_leave("cmdline", 0, true)
    end,
    ["/"] = function()
      require("imas").im_enter("search", 0, true)
    end,
    ["?"] = function()
      require("imas").im_leave("search", 0, true)
    end,
    ["t"] = function()
      require("imas").im_enter("terminal", 0, true)
    end,
    ["T"] = function()
      require("imas").im_leave("terminal", 0, true)
    end,
    ["d"] = function()
      require("imas").im_default(true)
    end,
  }

  local server = vim.uv.new_tcp()
  assert(server ~= nil, "im-autoswitch: new tcp error")
  server:bind(host, port)
  server:listen(128, function(err)
    assert(err == nil, err)
    local client = vim.uv.new_tcp()
    assert(client ~= nil, "im-autoswitch: new tcp error")
    server:accept(client)
    vim.print("accept a client")
    client:keepalive(true, 300)
    client:read_start(function(err, chunk)
      assert(err == nil, err)
      if chunk then
        for i = 1, #chunk do
          local char = chunk:sub(i, i)
          msg_to_func[char]()
        end
      else
        client:close()
      end
    end)
  end)
  vim.print(string.format("im-autoswitch: server listening at %s:%d", host, port))
  return server
end

return M
