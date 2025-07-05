if not Global_config.im then
  return {}
end

return {
  -- Input method auto switching
  "Old-Farmer/im-autoswitch.nvim",
  -- dev = true,
  event = "BufEnter",
  opts = {
    cmd_os = {
      -- linux = {
      --   default_im = "1",
      --   get_im_cmd = "fcitx5-remote",
      --   switch_im_cmd = "fcitx5-remote -t",
      -- },
      linux = {
        default_im = "keyboard-us",
        get_im_cmd = "fcitx5-remote -n",
        switch_im_cmd = "fcitx5-remote -s {}",
      },
    },
    mode = {
      terminal = false,
    },
  },
}
