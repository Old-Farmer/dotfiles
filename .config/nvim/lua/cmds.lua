-- User commands

local command = vim.api.nvim_create_user_command

-- Set pwd to Current file dir
command("CdCurrentFileDir", "cd %:p:h", {})

-- Indentation cmds
command("TabIndent", function(opts)
  if opts.nargs == 1 then
    local n = tonumber(opts.fargs[1])
    if n == nil then
      n = 4
    end
    Easynvim.set_indentation("", "tab", n)
  end
end, { nargs = "?" })
command("SpaceIndent", function(opts)
  if opts.nargs == 1 then
    local n = tonumber(opts.fargs[1])
    if n == nil then
      n = 4
    end
    Easynvim.set_indentation("", "spaces", n)
  end
end, { nargs = "?" })
command("MixedIndent", function(opts)
  if opts.nargs == 1 then
    local n = tonumber(opts.fargs[1])
    if n == nil then
      n = 4
    end
    Easynvim.set_indentation("", "mixed", n)
  end
end, { nargs = "?" })

command("RemoveCR", function()
  vim.cmd([[%s/\r$//g]])
end, { force = true })
